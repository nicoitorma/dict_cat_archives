import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:flutter/material.dart';

class ProjectContents extends StatefulWidget {
  const ProjectContents({super.key, required this.project});
  final Project project;

  @override
  State<ProjectContents> createState() => _ProjectContentsState();
}

class _ProjectContentsState extends State<ProjectContents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.project.docId),
      body: const Center(
        child: Text('CONTENTS'),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
