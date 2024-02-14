import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key, required this.title});
  final String title;
  final double barHeight = 50.0;


  @override
  Widget build(BuildContext context) {
   return AppBar(title: Text(title, style: const TextStyle(color: Colors.white, 
      shadows: [Shadow(
        offset: Offset(1.0, 1.0),
        color: Colors.grey)])),
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(180, 0, 83, 184), Color.fromARGB(120, 62, 180, 137)], begin: Alignment.bottomLeft, end: Alignment.topRight)),),);
      
  }
  
  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}
