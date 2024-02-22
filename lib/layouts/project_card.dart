import 'package:dict_cat_archives/layouts/base_card.dart';
import 'package:flutter/material.dart';

class ProjectCard extends BaseCard {
  const ProjectCard(
      {super.key, super.onTap, super.deleteOnTap, required super.project});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(180, 226, 226, 226),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 15.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: deleteOnTap,
                        child: const Opacity(
                          opacity: .5,
                          child: Icon(Icons.delete, size: 20),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        project.background!,
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const SizedBox(
                              height: 100,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Error loading image')));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      project.docId,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
