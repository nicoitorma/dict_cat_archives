class ProjectInfo {
  String docId;
  String background;
  String title;
  DateTime? dateConducted;
  DateTime? dateAccomplished;
  DateTime? time;
  String? municipality;
  String? sector;
  String? mode;
  String? conductedBy;
  String? resourcePerson;
  int? maleCount;
  int? femaleCount;

  ProjectInfo(
      {required this.docId,
      required this.background,
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
      this.femaleCount});

  ProjectInfo.fromJson(String doc, Map<String, dynamic> item)
      : docId = doc,
        title = item['title'],
        background = item['background'],
        dateConducted = item['project']['dateConducted'] ?? '',
        dateAccomplished = item['project']['dateAccomplished'] ?? '',
        time = item['project']['time'] ?? '',
        municipality = item['project']['municipality'] ?? '',
        sector = item['project']['sector'] ?? '',
        mode = item['project']['mode'] ?? '',
        conductedBy = item['project']['conductedBy'] ?? '',
        resourcePerson = item['project']['resourcePerson'] ?? '',
        maleCount = item['project']['maleCount'] ?? '',
        femaleCount = item['project']['dateConducted'] ?? '';
}
