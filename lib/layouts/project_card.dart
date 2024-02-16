import 'package:dict_cat_archives/layouts/base_card.dart';
import 'package:flutter/material.dart';

class ProjectCard extends BaseCard {
  const ProjectCard({super.key, super.onTap, required super.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 3,
        child: Stack(alignment: Alignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset(
                    project.background,
                    fit: BoxFit.contain,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool? wasSynchronouslyLoaded) {
                      return child;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(project.docId,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
