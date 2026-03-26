import 'package:flutter/material.dart';
import 'package:td2/UI/widgets/addtask.dart';
import 'package:td2/UI/widgets/ecransetting.dart';
import 'mytheme.dart';
import 'views/views.dart';

class home extends StatefulWidget{
  const home();



  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
  }

  static List<Widget> _widgets = <Widget>[
    TasksVue(), remoteTaskView(), PostVue(), EcranSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: MyTheme.darkTextTheme.titleLarge,
        title: const Text("Titre"),
        centerTitle: true,
      ),
      floatingActionButton: _selectedIndex==0?FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddTask(),
          )
          );
        },        child: const Icon(Icons.add),):const SizedBox.shrink(),
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Compte'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Param'),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
      ),
    );
  }
}