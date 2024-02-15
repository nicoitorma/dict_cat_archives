import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.transparent,
                    foregroundImage: AssetImage('assets/images/DICT-logo.png'),
                  ),
                  Text(email),
                ],
              )),
        ),
        ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()))),
        const ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        const ListTile(
          leading: Icon(Icons.logout),
          title: Text('Log out'),
        )
      ],
    ));
  }
}
