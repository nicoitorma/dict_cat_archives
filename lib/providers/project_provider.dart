import 'package:dict_cat_archives/firebase_query/fetch_projects.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:flutter/material.dart';

class ProjectListProvider extends ChangeNotifier {
  List<Project> projects = [];

  fetchProjects() async {
    List projectList = await fetchAllProjects();
    projects.clear();

    for (var est in projectList) {
      projects.add(est);
    }

    notifyListeners();
  }
}
