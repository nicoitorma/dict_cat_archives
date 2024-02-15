import 'package:dict_cat_archives/firebase_query/fetch_projects.dart';
import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/layouts/drawer.dart';
import 'package:dict_cat_archives/layouts/project_card.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appName),
      drawer: CustomDrawer(email: '${auth.currentUser?.email}'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchAllProjects(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            List<Project> projects = snapshot.data as List<Project>;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                Project proj = projects[index];

                return ProjectCard(project: proj);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
