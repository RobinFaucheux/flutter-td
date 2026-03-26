import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/tasks.dart';
import '../../viewmodels/taskviewmodel.dart';

class AddTask extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Center(
        child: AddTaskForm(),
      ),
    ) ;
  }
}

class AddTaskForm extends StatefulWidget{
  const AddTaskForm({super.key});
  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final controlleurTexteTitle = TextEditingController();
  final controlleurTexteTags = TextEditingController();
  final controlleurNbH = TextEditingController();
  final controlleurDiff = TextEditingController();
  final controlleurDesc = TextEditingController();


  // int id;
  // String title;
  // List<String> tags;
  // int nbhours;
  // int difficuty;
  // String description;

  @override
  void dispose()
  {
    controlleurTexteTitle.dispose();
    controlleurTexteTags.dispose();
    controlleurNbH.dispose();
    controlleurDiff.dispose();
    controlleurDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Nom",
            ),
            controller: controlleurTexteTitle,
            validator: (value) {
              if (value == null || value.isEmpty)
                {
                  return "Veuillez entrer quelque chose";
                }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Tags",
            ),
            controller: controlleurTexteTags,
            validator: (value) {
              if (value == null || value.isEmpty)
              {
                return "Veuillez entrer quelque chose";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Nombre d'heures",
            ),
            controller: controlleurNbH,
            validator: (value) {
              if (value == null || value.isEmpty)
              {
                return "Veuillez entrer quelque chose";
              }
              else if (double.tryParse(value) == null)
                {
                  return "Veuillez entrer un nombre";
                }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Difficulte",
            ),
            controller: controlleurDiff,
            validator: (value) {
              if (value == null || value.isEmpty)
              {
                return "Veuillez entrer quelque chose";
              }
              else if (double.tryParse(value) == null)
              {
                return "Veuillez entrer un nombre";
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Description",
            ),
            controller: controlleurDesc,
            validator: (value) {
              if (value == null || value.isEmpty)
              {
                return "Veuillez entrer quelque chose";
              }
            },
          ),
          ElevatedButton(
              onPressed: (){
                if (_formKey.currentState!.validate())
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Traitement des donnees"))
                    );
                    String title = controlleurTexteTitle.text;
                    String tag = controlleurTexteTags.text;
                    int nbH = int.parse(controlleurNbH.text);
                    int difficulty = int.parse(controlleurDiff.text);
                    String desc = controlleurDesc.text;
                    context.read<TaskViewModel>().addTask(Task.nwTask(title, [tag], nbH, difficulty, desc));


                    Navigator.pop(context);
                  }
              },
              child: const Text('Envoyer')),
        ],
      ),
    );
  }
}
