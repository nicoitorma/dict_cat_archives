class Project {
  String docId;
  String background;

  Project({required this.docId, required this.background});

  Project.fromJson(String doc, Map<String, dynamic> item)
      : docId = doc,
        background = item['background'];
}
