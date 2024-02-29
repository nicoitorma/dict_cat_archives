import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final db = FirebaseFirestore.instance;
CollectionReference collection = db.collection('abouts');

Future<List<Project>> fetchAllProjects() async {
  List<Project> projectsList = [];
  try {
    var query = await collection.get();

    // Fetch all documents in the collection
    for (QueryDocumentSnapshot doc in query.docs) {
      String docId = doc.id;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      projectsList.add(Project.fromJson(docId, data));
    }
  } catch (err) {
    debugPrint(err.toString());
  }

  return projectsList;
}

addNewProject(Project project) async {
  try {
    String imageUrl = await uploadImage(
        kIsWeb ? project.imageList : project.image, project.docId);

    await db
        .collection(labelAboutsCollection)
        .doc(project.docId)
        .set({'background': imageUrl, 'count': 0});

    await db.collection(labelProjectCollection).doc(project.docId).set({});
  } catch (err) {
    debugPrint(err.toString());
  }
}

updateActivityCountFirebase(String docId, int count) async {
  await db
      .collection(labelAboutsCollection)
      .doc(docId)
      .update({'count': count});
}

deleteProjectOnFirebase(Project project) async {
  try {
    DocumentReference projectRef =
        db.collection(labelProjectCollection).doc(project.docId);
    DocumentReference aboutRef =
        db.collection(labelAboutsCollection).doc(project.docId);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('about/${project.docId}.png');

    await projectRef.delete();
    await aboutRef.delete();
    await storageRef.delete();
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future uploadImage(var image, String filename) async {
  if (image == null) return;

  // Upload image to Firebase Storage
  Reference ref = FirebaseStorage.instance.ref().child('about/$filename.png');
  UploadTask uploadTask = ref.putData(
    image,
    SettableMetadata(contentType: 'image/png'),
  );
  TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
  String imageUrl = await snapshot.ref.getDownloadURL();

  return imageUrl;
}
