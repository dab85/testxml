import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class Books {
  final String title;
  final double price;
  Books(this.title, this.price);
}

void main() async {
  // var url = 'http://xn--80adi4aqt8a.xn--p1ai/lite/countzak.php';
  //var client = new http.Client();
  // var request = new http.Request('POST', Uri.parse(url));
  //var body = {'content':'this is a test', 'email':'john@doe.com', 'number':'441276300056'};
//  request.headers[HttpHeaders.CONTENT_TYPE] = 'application/json; charset=utf-8';
  //request.headers[HttpHeaders.AUTHORIZATION] = 'Basic 021215421fbe4b0d27f:e74b71bbce';
  //request.bodyFields = body;
  //var future = client.send(request);
  /*.then((response) => response.stream
          .bytesToString()
          .then((value) => print(value.toString())))
      .catchError((error) => print(error.toString()));*/

  var response =
      await http.post('http://xn--80adi4aqt8a.xn--p1ai/lite/getall.php', body: {
    'mail': 'bd85@mail.ru',
    'pass': 'reshuvam',
  });
  String result = response.body;

  print(result);

  final bookshelfXml = '''<?xml version="1.0"?>
    <bookshelf>
      <book>
        <title lang="english">Growing a Language</title>
        <price>29.98</price>
      </book>
      <book>
        <title lang="english">Learning XML</title>
        <price>39.95</price>
      </book>
      <price>132.00</price>
    </bookshelf>''';
  final bookshelfXml1 = result;

  final document = XmlDocument.parse(bookshelfXml1);
  final textual = document.descendants
      .where((node) => node is XmlText && !node.text.trim().isEmpty);
  List<Books> list = new List<Books>();
  List<Books> list2 = new List<Books>();

  textual.forEach((element) {
//    print(element);
  });

  /*final titles = document.root
      .findAllElements('record')
      .map((node) => (node.findElements('zakaz').single.text));
  final prices = document
      .findAllElements('book')
      .map((node) => double.parse(node.findElements('sum').single.text));
  for (int i = 0; i < titles.length; i++)
    list.add(new Books(titles.elementAt(i), prices.elementAt(i)));
*/
  final total2 = document.findAllElements('record');

  total2.forEach((element) {
    list2.add(new Books(element.getElement('zakaz').text,
        double.parse(element.getElement('sum').text)));
  });

  list2.forEach((element) {
    // print(element.title + " " + element.price.toString());
  });

  runApp(
    MaterialApp(
      title: 'Passing Data',
      home: TodosScreen(todos: list2),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  final List<Books> todos;

  TodosScreen({Key key, @required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Заявка " + todos[index].title),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current todo through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Books todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        title: Text("Название: " + todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Цена: " + todo.price.toString()),
      ),
    );
  }
}
