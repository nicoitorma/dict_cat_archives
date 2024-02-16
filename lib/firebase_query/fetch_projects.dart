import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;
CollectionReference collection = db.collection('projects');

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
