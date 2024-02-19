import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/layouts/drawer.dart';
import 'package:dict_cat_archives/layouts/project_card.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/routes/project_contents.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProjectListProvider>(context, listen: false);
    provider.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appName),
      drawer: CustomDrawer(email: '${auth.currentUser?.email}'),
      body: Consumer<ProjectListProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: (value.projects.length > 1)
                    ? LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount;
                        if (constraints.maxWidth < 600) {
                          crossAxisCount = 2;
                        } else if (constraints.maxWidth < 1100) {
                          crossAxisCount = 3;
                        } else {
                          crossAxisCount = value.projects.length;
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
                                          childCurrent: widget)));
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
    );
  }
}
