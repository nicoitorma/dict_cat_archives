import 'package:dict_cat_archives/firebase_query/fetch_project_contents.dart';
import 'package:dict_cat_archives/models/project_info.dart';
import 'package:flutter/material.dart';

class ProjectContentsProvider extends ChangeNotifier {
  List<ProjectInfo> projectContents = [];

  fetchProjectContents(String docId) async {
    List projectContentsList = await fetchAllProjectContents(docId);
    projectContents.clear();

    for (var proj in projectContentsList) {
      projectContents.add(proj);
    }

    notifyListeners();
  }

  void addProjectContent(ProjectInfo projectInfo) async {
    await addProjectToFirebase(projectInfo);
    projectContents.add(projectInfo);
    notifyListeners();
  }
}
