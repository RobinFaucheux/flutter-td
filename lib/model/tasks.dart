import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../DB/database.dart';

class Task {
  int id;
  String title;
  List<String> tags;
  int nbhours;
  int difficuty;
  String description;
  static int nb = 0;
  Task({required this.id,required this.title,required this.tags,required
  this.nbhours,required this.difficuty,required this.description});

  factory Task.newTask(){
    nb++;
    return Task(id: nb, title: 'title $nb', tags: ['tags $nb'], nbhours: nb, difficuty: nb%5, description: 'description $nb');
  }

  Map<String, Object?> toMap(){
    return {'id':id, 'title':title, 'tags': tags, 'nbhours':nbhours, 'difficuty':difficuty, 'description':description};
  }



  factory Task.nwTask(String title, List<String> tags,int nbhours, int difficulty,String description)
  {
    nb++;
    Task t = Task(id: nb, title: title, tags: tags, nbhours: nbhours, difficuty: difficulty, description: description);
    return t;
  }


  static List<Task> generateTask(int i){
    List<Task> tasks=[];
    for(int n=0;n<i;n++){
      tasks.add(Task(id: n, title: "title $n", tags: ['tag $n','tag ${n+1}'], nbhours: n, difficuty: n, description: '$n'));
          }
          return tasks;
      }
      static Task fromJson(Map<String, dynamic> json)
      {
        return Task(
          id: json['id'],
          title: json['title'],
          tags: List<String>.from(json['tags']),
          nbhours: json['nbhours'],
          difficuty: json['difficulty'],
          description: json['description'],);
      }

}
class Post{
  int id;
  int userId;
  String title;
  String body;
  Post({required this.id, required this.userId, required this.title, required this.body});

  static Post fromJson(Map<String, dynamic> json)
  {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body']
    );
  }

}


class MyAPI{
  Future<List<Task>> getTasks() async{
    await Future.delayed(Duration(seconds: 1));
    final dataString = await _loadAsset('json/tasks.json');
    final Map<String,dynamic> json = jsonDecode(dataString);
    if (json['tasks']!=null){
      final tasks = <Task>[];
      json['tasks'].forEach((element){
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    }else{
      return [];
    }
  }
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}

class RemoteApi{
  Future<List<Post>> getPosts() async
  {

    String url = "https://jsonplaceholder.typicode.com/posts";
    Future<http.Response> fetchPosts(String url) async {
      final rep =  await http.get(Uri.parse(url));
      return rep;
    }
    List<Post> listPosts = [];
    final rep = await fetchPosts(url);
    if (rep.statusCode == 200)
    {
      print(rep.body);
      List<dynamic> LPosts = jsonDecode(rep.body);
      listPosts = LPosts.map((post) => Post.fromJson(post)).toList();
    }
    else
      {
        throw Exception("Erreure");
      }
    return listPosts;
  }
}