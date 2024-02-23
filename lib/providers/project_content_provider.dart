import 'package:dict_cat_archives/firebase_query/project_contents_query.dart';
import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:flutter/material.dart';

class ProjectContentsProvider extends ChangeNotifier {
  List<ActivityInfo> projectContents = [];

  fetchActivity(String docId) async {
    List projectContentsList = await fetchAllProjectContents(docId);
    projectContents.clear();

    for (var proj in projectContentsList) {
      projectContents.add(proj);
    }

    notifyListeners();
  }

  void addActivity(ActivityInfo projectInfo, int count) async {
    await addProjectToFirebase(projectInfo, count);
    projectContents.add(projectInfo);
    notifyListeners();
  }

  deleteActivity(List<ActivityInfo> activityInfo, int count) async {
    for (var activity in activityInfo) {
      projectContents.remove(activity);
      await deleteActivityOnFirebase(activity, count, activityInfo.length);
    }
    notifyListeners();
  }

  void uploadPhoto(ActivityInfo activity, var photo) async {
    await addPhotoInActivity(activity, photo);
    fetchActivity(activity.docId);
  }
}
