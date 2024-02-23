class ActivityInfo {
  String docId;
  String title;
  String? dateConducted;
  String? dateAccomplished;
  String? time;
  String? municipality;
  String? sector;
  String? mode;
  String? conductedBy;
  String? resourcePerson;
  int? maleCount;
  int? femaleCount;
  List<String>? images;
  bool isChecked = false;
  String? remarks;
  String? link;

  ActivityInfo(
      {required this.docId,
      required this.title,
      this.dateConducted,
      this.dateAccomplished,
      this.time,
      this.municipality,
      this.sector,
      this.mode,
      this.conductedBy,
      this.resourcePerson,
      this.maleCount,
      this.femaleCount,
      this.remarks,
      this.link,
      this.images});

  ActivityInfo.fromJson(String doc, String key, Map<String, dynamic> item)
      : docId = doc,
        title = key,
        dateConducted = item['dateConducted'] ?? '',
        dateAccomplished = item['dateAccomplished'] ?? '',
        time = item['time'] ?? '',
        municipality = item['municipality'] ?? '',
        sector = item['sector'] ?? '',
        mode = item['mode'] ?? '',
        conductedBy = item['conductedBy'] ?? '',
        resourcePerson = item['resourcePerson'] ?? '',
        maleCount = item['maleCount'] ?? 0,
        femaleCount = item['femaleCount'] ?? 0,
        remarks = item['remarks'],
        link = item['link'],
        images = item['images'];
}
