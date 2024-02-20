import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dict_cat_archives/models/project_info.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

Future<List<ProjectInfo>> fetchAllProjectContents(String docId) async {
  DocumentSnapshot documentSnapshot =
      await db.collection('projects').doc(docId).get();
  List<ProjectInfo> projectsContentsList = [];

  try {
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      data.forEach((key, item) {
        var projectInfo = ProjectInfo.fromJson(docId, key, item);
        projectsContentsList.add(projectInfo);
      });
    }
  } catch (err) {
    debugPrint(err.toString());
  }

  return projectsContentsList;
}

addProjectToFirebase(ProjectInfo projectInfo) async {
  try {
    await db.collection(labelProjectCollection).doc(projectInfo.docId).update({
      projectInfo.title: {
        'dateConducted': projectInfo.dateConducted,
        'dateAccomplished': projectInfo.dateAccomplished,
        'time': projectInfo.time,
        'municipality': projectInfo.municipality,
        'sector': projectInfo.sector,
        'mode': projectInfo.mode,
        'resourcePerson': projectInfo.resourcePerson,
        'conductedBy': projectInfo.conductedBy,
        'maleCount': projectInfo.maleCount,
        'femaleCount': projectInfo.femaleCount
      }
    });
  } catch (err) {
    debugPrint(err.toString());
  }
}
