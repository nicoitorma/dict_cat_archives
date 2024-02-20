import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:flutter/material.dart';

class ActivityDetails extends StatefulWidget {
  final String project;
  const ActivityDetails({super.key, required this.project});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: widget.project),
        body: const Center(
          child: Text('HEHE'),
        ));
  }
}
