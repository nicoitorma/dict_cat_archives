import 'package:dict_cat_archives/firebase_query/project_contents.dart';
import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:flutter/material.dart';

class ProjectContentsProvider extends ChangeNotifier {
  List<ActivityInfo> projectContents = [];

  fetchProjectContents(String docId) async {
    List projectContentsList = await fetchAllProjectContents(docId);
    projectContents.clear();

    for (var proj in projectContentsList) {
      projectContents.add(proj);
    }

    notifyListeners();
  }

  void addProjectContent(ActivityInfo projectInfo, int count) async {
    await addProjectToFirebase(projectInfo, count);
    projectContents.add(projectInfo);
    notifyListeners();
  }

  void uploadPhoto(ActivityInfo activity, var photo) async {
    await addPhotoInActivity(activity, photo);
    fetchProjectContents(activity.docId);
  }
}
