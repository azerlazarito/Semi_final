
import 'package:flutter/material.dart';
import 'package:semi/todo_list.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    title: "Semi-Final",
    home: const TodoList(),
  ));
}