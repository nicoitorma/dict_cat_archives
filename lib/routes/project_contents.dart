import 'package:dict_cat_archives/firebase_query/fetch_project_contents.dart';
import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/models/project_info.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:flutter/material.dart';

class ProjectContents extends StatefulWidget {
  const ProjectContents({super.key, required this.project});
  final Project project;

  @override
  State<ProjectContents> createState() => _ProjectContentsState();
}

class _ProjectContentsState extends State<ProjectContents> {
  TextStyle header = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    dateConducted.dispose();
    dateAccomplished.dispose();
    municipality.dispose();
    time.dispose();
    sector.dispose();
    resource.dispose();
    conducted.dispose();
    male.dispose();
    female.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.project.docId),
      body: FutureBuilder(
        future: fetchAllProjectContents(widget.project.docId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ProjectInfo> projectList = snapshot.data!;
          return Align(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 10,
                  columns: [
                    DataColumn(label: Text(labelTitle, style: header)),
                    DataColumn(label: Text(labelDateConducted, style: header)),
                    DataColumn(
                        label: Text(labelDateAccomplished, style: header)),
                    DataColumn(label: Text(labelTime, style: header)),
                    DataColumn(label: Text(labelMunicipality, style: header)),
                    DataColumn(label: Text(labelSector, style: header)),
                    DataColumn(label: Text(labelMode, style: header)),
                    DataColumn(label: Text(labelConductedBy, style: header)),
                    DataColumn(label: Text(labelResourcePerson, style: header)),
                    DataColumn(label: Text('Male Count', style: header)),
                    DataColumn(label: Text('Female Count', style: header)),
                  ],
                  rows: projectList.map((content) {
                    return DataRow(cells: [
                      DataCell(
                          InkWell(onTap: () {}, child: Text(content.title))),
                      DataCell(Text(content.dateConducted.toString())),
                      DataCell(Text(content.dateAccomplished.toString())),
                      DataCell(Text(content.time.toString())),
                      DataCell(Text(content.municipality.toString())),
                      DataCell(Text(content.sector.toString())),
                      DataCell(Text(content.mode.toString())),
                      DataCell(Text(content.conductedBy.toString())),
                      DataCell(Text(content.resourcePerson.toString())),
                      DataCell(Text(content.maleCount.toString())),
                      DataCell(Text(content.femaleCount.toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addProjectContent(context);
          },
          child: const Icon(Icons.add)),
    );
  }

  String? _selectedMode;
  TextEditingController title = TextEditingController();
  TextEditingController dateConducted = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController municipality = TextEditingController();
  TextEditingController dateAccomplished = TextEditingController();
  TextEditingController sector = TextEditingController();
  TextEditingController conducted = TextEditingController();
  TextEditingController resource = TextEditingController();
  TextEditingController male = TextEditingController();
  TextEditingController female = TextEditingController();

  void _addProjectContent(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(labelAddInformation),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / .6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      decoration: InputDecoration(labelText: labelTitle),
                      controller: title),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: _buildDatePicker(
                            context, labelDateConducted, dateConducted),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: _buildTimePicker(context, labelTime, time)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDatePicker(
                      context, labelDateAccomplished, dateAccomplished),
                  const SizedBox(height: 10),
                  TextField(
                      decoration: InputDecoration(labelText: labelMunicipality),
                      controller: municipality),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                            decoration: InputDecoration(labelText: labelSector),
                            controller: sector),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          hint: Text(labelMode),
                          value: _selectedMode,
                          onChanged: (String? newValue) {
                            _selectedMode = newValue;
                          },
                          items: <String>['Online', 'Face-to-face']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                            decoration:
                                InputDecoration(labelText: labelResourcePerson),
                            controller: resource),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                            decoration:
                                InputDecoration(labelText: labelConductedBy),
                            controller: conducted),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                            decoration: InputDecoration(
                                labelText: labelMaleParticipants),
                            controller: male),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                            decoration: InputDecoration(
                                labelText: labelFemaleParticipants),
                            controller: female),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(labelClose),
            ),
            ElevatedButton(
              onPressed: () {
                _saveInformation(context);
              },
              child: Text(labelSave),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context, String labelText,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () {
        _selectDate(context, labelText, controller);
      },
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String labelText,
      TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  Widget _buildTimePicker(BuildContext context, String labelText,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () {
        _selectTime(context, labelText, controller);
      },
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: const Icon(Icons.access_time),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, String labelText,
      TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        String hour = picked.hour.toString().padLeft(2, '0');
        String minute = picked.minute.toString().padLeft(2, '0');
        controller.text = '$hour:$minute';
      });
    }
  }

  void _saveInformation(BuildContext context) {
    // Retrieving values from text fields and printing
    print("Title: ${title.text}");
    print("Date Conducted: ${dateConducted.text}");
    print("Time: ${time.text}");
    print("Date Accomplished: ${dateAccomplished.text}");
    print("Sector: ${sector.text}");
    print("Mode: $_selectedMode");
    print("Resource Person: ${resource.text}");
    print("Conducted By: ${conducted.text}");

    Navigator.of(context).pop(); // Close the dialog
  }
}
