import 'package:dict_cat_archives/firebase_query/projects_query.dart';
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

  deleteProject(Project project) async {
    await deleteProjectOnFirebase(project);
    fetchProjects();
  }

  updateActivityCount(String docId, int count) async {
    await updateActivityCountFirebase(docId, count);
  }
}
