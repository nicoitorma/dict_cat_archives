import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.actions});
  final Widget title;
  final double barHeight = 50.0;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions ?? [],
      title: title,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(180, 0, 83, 184),
          Color.fromARGB(120, 62, 180, 137)
        ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}
