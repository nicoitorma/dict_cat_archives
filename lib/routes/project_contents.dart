import 'package:dict_cat_archives/firebase_query/fetch_project_contents.dart';
import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/models/project_info.dart';
import 'package:flutter/material.dart';

class ProjectContents extends StatefulWidget {
  const ProjectContents({super.key, required this.project});
  final Project project;

  @override
  State<ProjectContents> createState() => _ProjectContentsState();
}

class _ProjectContentsState extends State<ProjectContents> {
  TextStyle header = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.project.docId),
      body: FutureBuilder(
        future: fetchAllProjectContents(widget.project.docId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ProjectInfo> projectList = snapshot.data!;
          return Align(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 10,
                  columns: [
                    DataColumn(
                        label: Text('Title of the Activity', style: header)),
                    DataColumn(label: Text('Date Conducted', style: header)),
                    DataColumn(label: Text('Date Accomplished', style: header)),
                    DataColumn(label: Text('Time', style: header)),
                    DataColumn(label: Text('Municipality', style: header)),
                    DataColumn(label: Text('Sector', style: header)),
                    DataColumn(label: Text('Mode', style: header)),
                    DataColumn(label: Text('Conducted by', style: header)),
                    DataColumn(label: Text('Resource Person', style: header)),
                  ],
                  rows: projectList.map((content) {
                    return DataRow(cells: [
                      DataCell(
                          InkWell(onTap: () {}, child: Text(content.title))),
                      DataCell(Text(content.dateConducted.toString())),
                      DataCell(Text(content.dateAccomplished.toString())),
                      DataCell(Text(content.time.toString())),
                      DataCell(Text(content.municipality.toString())),
                      DataCell(Text(content.sector.toString())),
                      DataCell(Text(content.mode.toString())),
                      DataCell(Text(content.conductedBy.toString())),
                      DataCell(Text(content.resourcePerson.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
