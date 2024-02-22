import 'dart:io';

import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/layouts/bar_graph.dart';
import 'package:dict_cat_archives/layouts/drawer.dart';
import 'package:dict_cat_archives/layouts/project_card.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/providers/excel_export.dart';
import 'package:dict_cat_archives/providers/project_content_provider.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/routes/project_contents.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late ProjectListProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<ProjectListProvider>(context, listen: false);
    provider.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(appName)),
      drawer: CustomDrawer(email: '${auth.currentUser?.email}'),
      body: Consumer2<ProjectListProvider, ProjectContentsProvider>(
        builder: (context, value, activity, child) {
          return Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Card(
                    elevation: 3,
                    child: ActivityChart(project: value.projects)),
              )),
              Expanded(
                flex: 2,
                child: (value.projects.length > 1)
                    ? LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount;
                        if (constraints.maxWidth < 600) {
                          crossAxisCount = 2;
                        } else if (constraints.maxWidth < 1100) {
                          crossAxisCount = 3;
                        } else {
                          crossAxisCount = 6;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: value.projects.length,
                            itemBuilder: (context, index) {
                              Project proj = value.projects[index];
                              return ProjectCard(
                                project: proj,
                                onTap: () => Navigator.of(context).push(
                                    PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftJoined,
                                        child: ProjectContents(project: proj),
                                        duration:
                                            const Duration(milliseconds: 400),
                                        childCurrent: widget)),
                                exportOnTap: () async {
                                  await activity.fetchActivity(proj.docId);
                                  exportToExcel(
                                      activity.projectContents, proj.docId);
                                },
                                deleteOnTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title:
                                                Text('Delete ${proj.docId}?'),
                                            content: Text(labelDeleteProject),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(labelCancel)),
                                              TextButton(
                                                  onPressed: () {
                                                    value.deleteProject(proj);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(labelDelete)),
                                            ],
                                          ));
                                },
                              );
                            },
                          ),
                        );
                      })
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: ((context) => ImageTextPopup(provider: provider)));
          },
          child: const Icon(Icons.add)),
    );
  }
}

class ImageTextPopup extends StatefulWidget {
  final ProjectListProvider provider;
  const ImageTextPopup({super.key, required this.provider});

  @override
  ImageTextPopupState createState() => ImageTextPopupState();
}

class ImageTextPopupState extends State<ImageTextPopup> {
  TextEditingController project = TextEditingController();
  File? _image;
  Uint8List? imageList;
  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = await image.readAsBytes();
        setState(() {
          imageList = selected;
        });
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _image = selected;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Project'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: getImage,
              child: DottedBorder(
                child: AspectRatio(
                  aspectRatio: 2,
                  child: imageList != null
                      ? Image.memory(
                          imageList!,
                          fit: BoxFit.contain,
                        )
                      : _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                            ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: project,
              decoration: InputDecoration(
                hintText: labelProjectName,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(labelClose),
        ),
        TextButton(
          onPressed: () {
            Project newProject = Project(
                docId: project.text, image: _image, imageList: imageList);
            widget.provider.addProject(newProject);
            Navigator.of(context).pop();
          },
          child: Text(labelSave),
        ),
      ],
    );
  }
}
