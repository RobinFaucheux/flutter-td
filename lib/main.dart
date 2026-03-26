import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td2/DB/database.dart';
import 'package:td2/viewmodels/settingsviewmodel.dart';
import 'package:td2/viewmodels/taskviewmodel.dart';

import 'UI/home.dart';
import 'UI/mytheme.dart';

void main(){
  runApp(MyTD2());
}

class MyTD2 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_){
              SettingViewModel settingViewModel = SettingViewModel();
//getSettings est deja appelee dans le constructeur
              return settingViewModel;
            }),
        ChangeNotifierProvider(
            create:(_){
              TaskViewModel taskViewModel = TaskViewModel();
              return taskViewModel;
            } )
      ],
      child: Consumer<SettingViewModel>(
        builder: (context,SettingViewModel notifier,child){
          return MaterialApp(
              theme: notifier.isDark ? MyTheme.dark():MyTheme.light(),
              title: 'TD2',
              home: home()
          );
        },
      ),
    );
  }
}