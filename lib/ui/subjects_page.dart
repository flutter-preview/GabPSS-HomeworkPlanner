import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:homeworkplanner/models/main/subject.dart';
import 'package:homeworkplanner/models/tasksystem/task_host.dart';

class SubjectsPage extends StatefulWidget {
  final TaskHost host;
  final Function() onSubjectUpdate;

  const SubjectsPage({super.key, required this.host, required this.onSubjectUpdate});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();

  static void show(BuildContext context, TaskHost host, Function() onSubjectUpdate) {
    if (Platform.isAndroid) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectsPage(host: host, onSubjectUpdate: onSubjectUpdate),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SubjectsPage(host: host, onSubjectUpdate: onSubjectUpdate),
          );
        },
      );
    }
  }
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> subjectWidgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < widget.host.saveFile.Subjects.Items.length; i++) {
      subjectWidgets.add(Text(widget.host.saveFile.Subjects.Items[i].SubjectName));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit subjects')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var subject = widget.host.saveFile.Subjects.Items[index];
          return ListTile(
            leading: Icon(Icons.assignment_ind, color: subject.SubjectColorValue),
            title: Text(subject.SubjectName),
            onTap: () {
              showSubjectEditorDialog(context, subject);
            },
            trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete '${subject.SubjectName}'?"),
                      content: const Text("You won't be able to recover it once it's gone"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                widget.host.saveFile.Subjects.Items.remove(subject);
                              });
                              widget.onSubjectUpdate();
                            },
                            child: const Text("Delete")),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete)),
          );
        },
        itemCount: widget.host.saveFile.Subjects.Items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Subject newSubject = Subject();
          showSubjectEditorDialog(context, newSubject, true);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> showSubjectEditorDialog(BuildContext context, Subject subject, [bool isAdding = false]) {
    return showDialog(
      context: context,
      builder: (context) {
        List<Widget> dialogButtons = List.empty(growable: true);

        dialogButtons.add(const Spacer());
        if (isAdding) {
          dialogButtons.add(TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')));
        }
        dialogButtons.add(TextButton(
            onPressed: () {
              setState(() {
                if (isAdding) {
                  widget.host.saveFile.Subjects.addSubject(subject);
                }
              });
              widget.onSubjectUpdate();
              Navigator.pop(context);
            },
            child: const Text('OK')));

        return SimpleDialog(
          title: Text(isAdding ? 'Add subject' : 'Edit subject'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: subject.SubjectName,
                onChanged: (value) {
                  subject.SubjectName = value;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ColorPicker(
                enableAlpha: false,
                pickerColor: subject.SubjectColorValue,
                onColorChanged: (value) {
                  subject.SubjectColorValue = value;
                },
              ),
            ),
            Row(
              children: dialogButtons,
            )
          ],
        );
      },
    );
  }
}
