import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/models/project_info.dart';
import 'package:dict_cat_archives/providers/project_content_provider.dart';
import 'package:dict_cat_archives/routes/activity_details.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProjectContents extends StatefulWidget {
  const ProjectContents({super.key, required this.project});
  final Project project;

  @override
  State<ProjectContents> createState() => _ProjectContentsState();
}

class _ProjectContentsState extends State<ProjectContents> {
  TextStyle header = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle rowData = const TextStyle(fontSize: 16);
  late ProjectContentsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ProjectContentsProvider>(context, listen: false);
    provider.fetchProjectContents(widget.project.docId);
  }

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
      body: Consumer<ProjectContentsProvider>(
        builder: (context, value, child) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    horizontalMargin: 10,
                    columns: [
                      DataColumn(label: Text(labelTitle, style: header)),
                      DataColumn(
                          label: Text(labelDateConducted, style: header)),
                      DataColumn(
                          label: Text(labelDateAccomplished, style: header)),
                      DataColumn(label: Text(labelTime, style: header)),
                      DataColumn(label: Text(labelMunicipality, style: header)),
                      DataColumn(label: Text(labelSector, style: header)),
                      DataColumn(label: Text(labelMode, style: header)),
                      DataColumn(label: Text(labelConductedBy, style: header)),
                      DataColumn(
                          label: Text(labelResourcePerson, style: header)),
                      DataColumn(label: Text('Male Count', style: header)),
                      DataColumn(label: Text('Female Count', style: header)),
                    ],
                    rows: value.projectContents.map((content) {
                      return DataRow(cells: [
                        DataCell(InkWell(
                            onTap: () => Navigator.of(context).push(
                                PageTransition(
                                    type: PageTransitionType.rightToLeftJoined,
                                    child:
                                        ActivityDetails(project: content.title),
                                    duration: const Duration(milliseconds: 400),
                                    childCurrent: widget)),
                            child: Text(content.title,
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 16)))),
                        DataCell(Text(content.dateConducted.toString(),
                            style: rowData)),
                        DataCell(Text(content.dateAccomplished.toString(),
                            style: rowData)),
                        DataCell(Text(content.time.toString(), style: rowData)),
                        DataCell(Text(content.municipality.toString(),
                            style: rowData)),
                        DataCell(
                            Text(content.sector.toString(), style: rowData)),
                        DataCell(Text(content.mode.toString(), style: rowData)),
                        DataCell(Text(content.conductedBy.toString(),
                            style: rowData)),
                        DataCell(Text(content.resourcePerson.toString(),
                            style: rowData)),
                        DataCell(
                            Text(content.maleCount.toString(), style: rowData)),
                        DataCell(Text(content.femaleCount.toString(),
                            style: rowData)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addActivity(context);
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

  void _addActivity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(labelAddInformation),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .6,
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
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: labelFemaleParticipants,
                        ),
                        controller: male,
                        onChanged: (value) {
                          value = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (value.length > 5) {
                            value = value.substring(0, 5);
                          }
                          male.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: labelFemaleParticipants,
                        ),
                        controller: female,
                        onChanged: (value) {
                          value = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (value.length > 6) {
                            value = value.substring(0, 5);
                          }
                          female.value = TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                      )),
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
    ProjectInfo projectInfo = ProjectInfo(
        docId: widget.project.docId,
        title: title.text,
        dateConducted: dateConducted.text,
        dateAccomplished: dateAccomplished.text,
        time: time.text,
        municipality: municipality.text,
        sector: sector.text,
        mode: _selectedMode,
        resourcePerson: resource.text,
        conductedBy: conducted.text,
        maleCount: int.tryParse(male.text),
        femaleCount: int.tryParse(female.text));

    provider.addProjectContent(projectInfo);
    clearTextFields();
    Navigator.of(context).pop();
  }

  void clearTextFields() {
    title.clear();
    dateConducted.clear();
    dateAccomplished.clear();
    municipality.clear();
    time.clear();
    sector.clear();
    resource.clear();
    conducted.clear();
    male.clear();
    female.clear();
  }
}
