import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dict_cat_archives/models/project_info.dart';
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
      projectsContentsList.add(ProjectInfo.fromJson(docId, data));
    }
  } catch (err) {
    debugPrint(err.toString());
  }

  return projectsContentsList;
}
