import 'package:dict_cat_archives/firebase_query/fetch_projects.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:flutter/material.dart';

class ProjectListProvider extends ChangeNotifier {
  List<Project> projects = [];
  Project? selectedProject;

  fetchProjects() async {
    List projectList = await fetchAllProjects();
    projects.clear();

    for (var proj in projectList) {
      projects.add(proj);
    }

    notifyListeners();
  }

  addProject(Project project) async {
    await addNewProject(project);
    fetchProjects();
  }
}
