import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

Future<List<ActivityInfo>> fetchAllProjectContents(String docId) async {
  List<ActivityInfo> projectsContentsList = [];

  try {
    DocumentSnapshot documentSnapshot =
        await db.collection('projects').doc(docId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      data.forEach((key, item) {
        var projectInfo = ActivityInfo.fromJson(docId, key, item);
        projectsContentsList.add(projectInfo);
      });
    }
  } catch (err) {
    debugPrint(err.toString());
  }

  return projectsContentsList;
}

addProjectToFirebase(ActivityInfo projectInfo) async {
  try {
    await db.collection(labelProjectCollection).doc(projectInfo.docId).update({
      projectInfo.title: {
        'dateConducted': projectInfo.dateConducted,
        'dateAccomplished': projectInfo.dateAccomplished,
        'time': projectInfo.time,
        'municipality': projectInfo.municipality,
        'sector': projectInfo.sector,
        'mode': projectInfo.mode ?? '',
        'resourcePerson': projectInfo.resourcePerson,
        'conductedBy': projectInfo.conductedBy,
        'maleCount': projectInfo.maleCount ?? 0,
        'femaleCount': projectInfo.femaleCount ?? 0,
        'remarks': projectInfo.remarks,
        'link': projectInfo.link
      }
    });
  } catch (err) {
    debugPrint(err.toString());
  }
}

addPhotoInActivity(ActivityInfo activityInfo, var photo) async {
  try {
    String imageUrl = await uploadImage(
        activityInfo.docId, activityInfo.images!.length, photo);

    await db.collection(labelAboutsCollection).doc(activityInfo.docId).update({
      'images': imageUrl,
    });
  } catch (err) {
    debugPrint(err.toString());
  }
}

deleteActivityOnFirebase(
    ActivityInfo activityInfo, int count, int deductionCount) async {
  try {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(labelProjectCollection)
        .doc(activityInfo.docId);

    await documentReference.update({
      activityInfo.title: FieldValue.delete(),
    });

    await db
        .collection(labelAboutsCollection)
        .doc(activityInfo.docId)
        .update({'count': count - deductionCount});
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future uploadImage(String title, int index, var image) async {
  if (image == null) return;

  // Upload image to Firebase Storage
  Reference ref = FirebaseStorage.instance.ref().child('$title/$image');
  UploadTask uploadTask = ref.putData(
    image,
    SettableMetadata(contentType: 'image/png'),
  );
  TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
  String imageUrl = await snapshot.ref.getDownloadURL();

  return imageUrl;
}
