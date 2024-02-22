import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class CustomProfileScreen extends StatefulWidget {
  const CustomProfileScreen({super.key});

  @override
  State<CustomProfileScreen> createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: labelProfile),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                  child: Text('${auth.currentUser?.email}',
                      style: const TextStyle(fontSize: 20))),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Center(child: EditableUserDisplayName()),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 30),
                child:
                    Text('You can recover your password in the Login page.')),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(labelSignOut)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                height: 40,
                width: 200,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: Text(labelDeleteAccount),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(labelCancel)),
                                  TextButton(
                                      onPressed: () {
                                        auth.currentUser?.delete();
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                      },
                                      child: Text(labelContinue))
                                ],
                              ));
                    },
                    child: Text(labelDeleteAccount)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
