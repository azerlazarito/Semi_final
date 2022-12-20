
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class AddToDo extends StatefulWidget {
  final List? items;
  final Map? todo;
  const AddToDo({super.key, this.todo, this.items});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final desc = todo['body'];
      titleController.text = title;
      descController.text = desc;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit List" : "Add to do"),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Enter Title",
                labelText: "Title"
              ),
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                hintText: "Enter Description",
                labelText: "Description"
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed:isEdit? updateData : addData, child: Text(isEdit ?"Edit":"Submit"))
          ],
        ),
      ),
    );
  }
  Future<void> updateData() async{
    final todo = widget.todo;
    if (todo == null){
      print("Error");
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    final url = "https://jsonplaceholder.typicode.com/posts/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
        uri,
        body: convert.jsonEncode(body),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200){
      titleController.text = '';
      descController.text = '';
      sucMessage('Success');
      setState(() {
        widget.items;
      });
    }
    else {
      sucMessage('Error');
    }
  }

  Future<void> addData() async{
    final title = titleController.text;
    final desc = descController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    const url = "https://jsonplaceholder.typicode.com/posts";
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: convert.jsonEncode(body),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }
    );
    if (response.statusCode == 201){
      titleController.text = '';
      descController.text = '';
      sucMessage('Success');
    }
    else {
      sucMessage('Error');
    }
  }
  void sucMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
