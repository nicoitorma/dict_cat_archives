import 'dart:io';
import 'dart:typed_data';

class Project {
  String docId;
  String? background;
  File? image;
  Uint8List? imageList;

  Project({required this.docId, this.background, this.image, this.imageList});

  Project.fromJson(String doc, Map<String, dynamic> item)
      : docId = doc,
        background = item['background'] ?? '';
}
