import 'package:dict_cat_archives/authentication/login.dart';
import 'package:dict_cat_archives/routes/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const CustomProfileScreen()))),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        )
      ],
    ));
  }
}
