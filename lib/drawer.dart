import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Drawer(
      child: Column(children: [
         DrawerHeader(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.transparent,
                    foregroundImage: AssetImage('assets/images/DICT-logo.png'),
                    ),
                    Text('DICT'),
                  ],
                )),
          ),
      ],)
    );
  }
}