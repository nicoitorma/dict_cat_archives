import 'package:dict_cat_archives/app_bar.dart';
import 'package:dict_cat_archives/drawer.dart';
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
    print(auth.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appName),
      drawer: CustomDrawer(email: '${auth.currentUser?.email}'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          children: const [
            Card(
                elevation: 3,
                child: Column(
                  children: [
                    Image(
                        height: 200,
                        width: 200,
                        image: AssetImage('assets/images/cybersec.png')),
                  ],
                )),
            Card(
                elevation: 3,
                child: Column(
                  children: [
                    Image(
                        height: 200,
                        width: 200,
                        image: AssetImage('assets/images/drmm.png')),
                  ],
                )),
            Card(
                elevation: 3,
                child: Column(
                  children: [
                    Image(
                        height: 200,
                        width: 200,
                        image: AssetImage('assets/images/dtc.png')),
                  ],
                )),
            Card(
                elevation: 3,
                child: Column(
                  children: [
                    Image(
                        height: 200,
                        width: 200,
                        image: AssetImage('assets/images/egov.png')),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
