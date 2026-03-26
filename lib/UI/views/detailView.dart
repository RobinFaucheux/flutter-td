import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/tasks.dart';
import '../../viewmodels/taskviewmodel.dart';

class DetailTask extends StatefulWidget {
  final Task task;
  const DetailTask({super.key, required this.task});

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController controlleurTexteTitle;
  late final TextEditingController controlleurTexteTags;
  late final TextEditingController controlleurNbH;
  late final TextEditingController controlleurDiff;
  late final TextEditingController controlleurDesc;

  @override
  void initState() {
    super.initState();
    controlleurTexteTitle = TextEditingController(text: widget.task.title);
    controlleurTexteTags = TextEditingController(text: widget.task.tags.toString());
    controlleurNbH = TextEditingController(text: widget.task.nbhours.toString());
    controlleurDiff = TextEditingController(text: widget.task.difficuty.toString());
    controlleurDesc = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    controlleurTexteTitle.dispose();
    controlleurTexteTags.dispose();
    controlleurNbH.dispose();
    controlleurDiff.dispose();
    controlleurDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nom"),
                controller: controlleurTexteTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer quelque chose";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Tags"),
                controller: controlleurTexteTags,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer quelque chose";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nombre d'heures"),
                controller: controlleurNbH,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer quelque chose";
                  } else if (int.tryParse(value) == null) {
                    return "Veuillez entrer un nombre entier";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Difficulte"),
                controller: controlleurDiff,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer quelque chose";
                  } else if (int.tryParse(value) == null) {
                    return "Veuillez entrer un nombre";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                controller: controlleurDesc,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer quelque chose";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Traitement des données"))
                      );

                      String title = controlleurTexteTitle.text;
                      String tag = controlleurTexteTags.text;
                      int nbH = int.parse(controlleurNbH.text);
                      int difficulty = int.parse(controlleurDiff.text);
                      String desc = controlleurDesc.text;

                      Task taskUpd = Task.nwTask(title, [tag], nbH, difficulty, desc);
                      taskUpd.id = widget.task.id;

                      context.read<TaskViewModel>().editTask(
                          taskUpd
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Enregistrer')),
              ElevatedButton(
                  onPressed: () {
                    context.read<TaskViewModel>().deleteTask(widget.task.id);

                    Navigator.pop(context);
                    },
                  child: const Text('Supprimer')),
            ],
          ),
        ),
      ),
    );
  }
}