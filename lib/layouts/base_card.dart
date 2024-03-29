import 'package:dict_cat_archives/models/project.dart';
import 'package:flutter/material.dart';

abstract class BaseCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback deleteOnTap;
  final VoidCallback exportOnTap;
  final Project project;

  const BaseCard(
      {super.key,
      required this.project,
      required this.exportOnTap,
      required this.deleteOnTap,
      this.onTap});

  @override
  Widget build(BuildContext context);
}
