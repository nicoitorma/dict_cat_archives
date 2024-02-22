import 'dart:typed_data';

import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;

void exportToExcel(List<ActivityInfo> activityInfos, String docId) async {
  // Create Excel file
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  // Add header row
  sheetObject.appendRow([
    const TextCellValue('Title'),
    const TextCellValue('Date Conducted'),
    const TextCellValue('Date Accomplished'),
    const TextCellValue('Time'),
    const TextCellValue('Municipality'),
    const TextCellValue('Sector'),
    const TextCellValue('Mode'),
    const TextCellValue('Conducted By'),
    const TextCellValue('Resource Person'),
    const TextCellValue('Male Count'),
    const TextCellValue('Female Count'),
  ]);

  // Add data to Excel sheet
  for (var activityInfo in activityInfos) {
    sheetObject.appendRow([
      TextCellValue(activityInfo.title),
      TextCellValue('${activityInfo.dateConducted}'),
      TextCellValue('${activityInfo.dateAccomplished}'),
      TextCellValue('${activityInfo.time}'),
      TextCellValue('${activityInfo.municipality}'),
      TextCellValue('${activityInfo.sector}'),
      TextCellValue('${activityInfo.mode}'),
      TextCellValue('${activityInfo.conductedBy}'),
      TextCellValue('${activityInfo.resourcePerson}'),
      TextCellValue(activityInfo.maleCount.toString()),
      TextCellValue(activityInfo.femaleCount.toString()),
    ]);
  }

  // Save Excel file as byte data
  List<int>? excelData = excel.encode();

  // Convert byte data to Blob
  final blob = html.Blob([Uint8List.fromList(excelData!)],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

  // Create download link
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", "$docId.xlsx")
    ..click();

  // Revoke the object URL to free up resources
  html.Url.revokeObjectUrl(url);
}
