import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:td2/viewmodels/taskviewmodel.dart';
import '../mytheme.dart';
import '../../model/tasks.dart';
import 'detailView.dart';

class TasksVue extends StatelessWidget
{
  late List<Task> tasks; //= Task.generateTask(50);
  String tags = '';

  @override
  Widget build(BuildContext context) {
    tasks = context.watch<TaskViewModel>().liste;
    List<Card> tasksWidgets = [];
    for (Task task in tasks)
    {
      tasksWidgets.add(
          Card(
              child:
              ListTile(
                leading: Text(task.id.toString()),
                title: Text(task.title),
                subtitle: Text(task.tags.toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailTask(task: task))
                  );
                },
              ))
      );
    }
    ListView lView = ListView(
      children: tasksWidgets,
    );
    return lView;
  }
}

class remoteTaskView extends StatefulWidget
{
  const remoteTaskView();

  @override
  State<remoteTaskView> createState() => _remoteTaskView2State();
}

  class _remoteTaskView2State extends State<remoteTaskView> {
    ListView generateListView(tasks)
    {
      List<Card> tasksWidgets = [];
      for (Task task in tasks)
      {
        tasksWidgets.add(
            Card(
                child:
                ListTile(
                  leading: Text(task.id.toString()),
                  title: Text(task.title),
                  subtitle: Text(task.tags.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailTask(task: task))
                    );
                  },
                ))
        );
      }
      ListView lView = ListView(
        children: tasksWidgets,
      );
      return lView;
    }
    Widget _generate_tasks()
    {
      MyAPI api = new MyAPI();
      Future<List<Task>> tasks = api.getTasks();
      FutureBuilder<List<Task>> fb =  FutureBuilder(
                future: tasks,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    {
                      return generateListView(snapshot.data);
                    }
                  else
                    {
                      return ListView(
                        children: [const Text("En attente de donnees")],
                      );
                    }
                  });
      return fb;
    }

  @override
  Widget build(BuildContext context) {
    return _generate_tasks();
  }
}




class PostVue extends StatefulWidget
{
  const PostVue();

  @override
  State<PostVue> createState() => _PostVueState();
}

class _PostVueState extends State<PostVue> {
  ListView generateListView(posts)
  {
    List<Card> postsWidgets = [];
    for (Post post in posts)
    {
      postsWidgets.add(
          Card(
              child:
              ListTile(
                leading: Text(post.id.toString()),
                title: Text(post.title),
                subtitle: Text(post.body),
              ))
      );
    }
    ListView lView = ListView(
      children: postsWidgets,
    );
    return lView;
  }
  Widget _generate_tasks()
  {
    Future<List<Post>> posts = RemoteApi().getPosts();
    FutureBuilder<List<Post>> fb =  FutureBuilder(
        future: posts,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
          {
            return generateListView(snapshot.data);
          }
          else
          {
            return ListView(
              children: [const Text("En attente de donnees")],
            );
          }
        });
    return fb;
  }

  @override
  Widget build(BuildContext context) {
    return _generate_tasks();
  }
}
