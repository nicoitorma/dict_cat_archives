import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/models/activity_info.dart';
import 'package:dict_cat_archives/models/project.dart';
import 'package:dict_cat_archives/providers/activities_provider.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class ProjectContents extends StatefulWidget {
  const ProjectContents({super.key, required this.project});
  final Project project;

  @override
  State<ProjectContents> createState() => _ProjectContentsState();
}

class _ProjectContentsState extends State<ProjectContents> {
  TextStyle header = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  TextStyle rowData = const TextStyle(fontSize: 16);
  bool selectAll = false;
  List<ActivityInfo> selected = [];
  bool isSearching = false;
  late List<ActivityInfo> filteredList = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<ActivityInfo> activities;
  late ProjectListProvider projectProvider;
  late ActivityProvider activityProvider;

  @override
  void initState() {
    super.initState();
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    projectProvider = Provider.of<ProjectListProvider>(context, listen: false);
    activityProvider.fetchActivity(widget.project.docId);
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
    remarksText.dispose();
    linkText.dispose();
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
          hintText: 'Search activity',
          hintStyle: TextStyle(color: Colors.white)),
      onChanged: (query) {
        setState(() {
          isSearching = query.isNotEmpty;
          if (!isSearching) filteredList.clear();
          filteredList = activityProvider.projectContents
              .where((content) =>
                  content.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      },
    );
  }

  List<Widget> buildActions(Widget items) {
    if (isSearching) {
      return [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              isSearching = false;
              filteredList.clear();
            });
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
        ),
        items
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(builder: (context, value, child) {
      activities = value.projectContents;
      updateActivityCount(widget.project.docId, activities.length);
      return Scaffold(
        appBar: CustomAppBar(
            title:
                isSearching ? buildSearchField() : Text(widget.project.docId),
            actions: buildActions(IconButton(
                onPressed: () {
                  selected.isEmpty
                      ? showDialog(
                          context: context,
                          builder: (_) =>
                              AlertDialog(content: Text(labelNoSelected)))
                      : showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(labelDeleteActivityTitle),
                            content: Text(labelDeleteActivity),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(
                                  context,
                                ).pop(),
                                child: Text(labelCancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  value
                                      .deleteActivity(selected,
                                          value.projectContents.length)
                                      .then((_) {
                                    Navigator.of(
                                      context,
                                    ).pop();
                                    selected.clear();
                                    selectAll = false;
                                  });
                                },
                                child: Text(labelDelete),
                              ),
                            ],
                          ),
                        );
                },
                icon: const Icon(Icons.delete)))),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addActivity(context);
            },
            child: const Icon(Icons.add)),
        body: Container(
          color: const Color.fromARGB(26, 0, 83, 184),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortAscending: isAscending,
                        sortColumnIndex: sortColumnIndex,
                        horizontalMargin: 10,
                        columns: dataColumns(),
                        rows: dataRows(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  updateActivityCount(String docId, int count) {
    projectProvider.updateActivityCount(
        widget.project.docId, activities.length);
  }

  // List of Columns for table
  List<DataColumn> dataColumns() => [
        DataColumn(
          label: Checkbox(
            value: selectAll,
            onChanged: (newValue) {
              setState(() {
                selectAll = newValue!;
                selected.clear();
                for (var content in activities) {
                  content.isChecked = selectAll;
                  if (content.isChecked) {
                    selected.add(content);
                  }
                }
              });
            },
          ),
        ),
        DataColumn(onSort: onSort, label: Text(labelTitle, style: header)),
        DataColumn(
            onSort: onSort, label: Text(labelDateConducted, style: header)),
        DataColumn(
            onSort: onSort, label: Text(labelDateAccomplished, style: header)),
        DataColumn(onSort: onSort, label: Text(labelTime, style: header)),
        DataColumn(
            onSort: onSort, label: Text(labelMunicipality, style: header)),
        DataColumn(onSort: onSort, label: Text(labelSector, style: header)),
        DataColumn(onSort: onSort, label: Text(labelMode, style: header)),
        DataColumn(label: Text(labelConductedBy, style: header)),
        DataColumn(label: Text(labelResourcePerson, style: header)),
        DataColumn(label: Text(labelMaleCount, style: header)),
        DataColumn(label: Text(labelFemaleCount, style: header)),
        DataColumn(label: Text(labelRemarks, style: header)),
        DataColumn(label: Text(labelLink, style: header))
      ];

  // List of Rows for table
  List<DataRow> dataRows() => (isSearching ? filteredList : activities).map(
        (content) {
          return DataRow(
            cells: [
              DataCell(
                Checkbox(
                  value: content.isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      content.isChecked = newValue!;
                      if (newValue == true) {
                        selected.add(content);
                      } else {
                        selected.remove(content);
                      }
                      (selected.length ==
                              (isSearching ? filteredList : activities).length)
                          ? selectAll = true
                          : selectAll = false;
                    });
                  },
                ),
              ),
              DataCell(Text(
                  overflow: TextOverflow.ellipsis,
                  content.title,
                  style: const TextStyle(fontSize: 16))),
              DataCell(Text(content.dateConducted.toString(), style: rowData)),
              DataCell(
                  Text(content.dateAccomplished.toString(), style: rowData)),
              DataCell(Text(content.time.toString(), style: rowData)),
              DataCell(Text(content.municipality.toString(), style: rowData)),
              DataCell(Text(content.sector.toString(), style: rowData)),
              DataCell(Text(content.mode.toString(), style: rowData)),
              DataCell(Text(content.conductedBy.toString(), style: rowData)),
              DataCell(Text(content.resourcePerson.toString(), style: rowData)),
              DataCell(Text(content.maleCount.toString(), style: rowData)),
              DataCell(Text(content.femaleCount.toString(), style: rowData)),
              DataCell(Text(content.remarks ?? '', style: rowData)),
              DataCell(
                GestureDetector(
                  onTap: () {
                    final url = content.link.toString();
                    if (url.isNotEmpty) {
                      html.window.open(url, '_blank');
                    }
                  },
                  child: Text(
                    _truncateUrl(content.link ?? ''),
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      ).toList();

  String _truncateUrl(String url) {
    const maxLength = 20;
    if (url.length <= maxLength) {
      return url;
    } else {
      return '${url.substring(0, maxLength - 3)}...';
    }
  }

  void onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 1:
        activities.sort((activity1, activity2) =>
            compareString(ascending, activity1.title, activity2.title));
        break;
      case 2:
        activities.sort((activity1, activity2) => compareString(
            ascending, activity1.dateConducted!, activity2.dateConducted!));
        break;
      case 3:
        activities.sort((activity1, activity2) => compareString(ascending,
            activity1.dateAccomplished!, activity2.dateAccomplished!));
        break;
      case 4:
        activities.sort((activity1, activity2) =>
            compareString(ascending, activity1.time!, activity2.time!));
        break;
      case 5:
        activities.sort((activity1, activity2) => compareString(
            ascending, activity1.municipality!, activity2.municipality!));
        break;
      case 6:
        activities.sort((activity1, activity2) =>
            compareString(ascending, activity1.sector!, activity2.sector!));
        break;
      case 7:
        activities.sort((activity1, activity2) =>
            compareString(ascending, activity1.mode!, activity2.mode!));
        break;
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

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
  TextEditingController remarksText = TextEditingController();
  TextEditingController linkText = TextEditingController();

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
                        child: buildDatePicker(
                            context, labelDateConducted, dateConducted),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: buildTimePicker(context, labelTime, time)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildDatePicker(
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
                          labelText: labelMaleParticipants,
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
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                            keyboardType: TextInputType.url,
                            decoration:
                                InputDecoration(labelText: labelRemarks),
                            controller: remarksText),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                            decoration: InputDecoration(labelText: labelLink),
                            controller: linkText),
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
                saveInformation(context);
              },
              child: Text(labelSave),
            ),
          ],
        );
      },
    );
  }

  Widget buildDatePicker(BuildContext context, String labelText,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () {
        selectDate(context, labelText, controller);
      },
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Future<void> selectDate(BuildContext context, String labelText,
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

  Widget buildTimePicker(BuildContext context, String labelText,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () {
        selectTime(context, labelText, controller);
      },
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: const Icon(Icons.access_time),
      ),
    );
  }

  Future<void> selectTime(BuildContext context, String labelText,
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

  void saveInformation(BuildContext context) {
    ActivityInfo projectInfo = ActivityInfo(
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
        remarks: remarksText.text,
        link: linkText.text,
        maleCount: int.tryParse(male.text),
        femaleCount: int.tryParse(female.text));

    activityProvider.addActivity(projectInfo);
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
    linkText.clear();
    remarksText.clear();
  }
}
