import 'dart:io';

import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:dict_cat_archives/providers/project_content_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ActivityDetails extends StatefulWidget {
  final ActivityInfo activityInfo;
  const ActivityDetails({super.key, required this.activityInfo});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: Text(widget.activityInfo.title)),
      body: Consumer<ProjectContentsProvider>(
        builder: (context, value, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  if (widget.activityInfo.images != null)
                    ...widget.activityInfo.images!.map((imageUrl) => ImageCard(
                          imageUrl: imageUrl,
                          screenWidth: screenWidth,
                        )),
                  Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        var photo = await getImage();
                        value.uploadPhoto(widget.activityInfo, photo);
                      },
                      child: const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Icon(Icons.add, size: 50),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Project Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DetailItem(
                        label: 'Resource Speaker',
                        value: widget.activityInfo.conductedBy!),
                    const DetailItem(
                        label: 'Conducted By', value: 'Organization X'),
                    const DetailItem(
                      label: 'Total Participants (M/F)',
                      value: '100 / 50',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = await image.readAsBytes();
        return selected;
      }
    } else {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        return selected;
      }
    }
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double screenWidth;

  const ImageCard(
      {super.key, required this.imageUrl, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Text('WORRDDD'),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
