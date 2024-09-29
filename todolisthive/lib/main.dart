import 'package:flutter/material.dart';
import 'package:todolisthive/home_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'panel.dart';
import 'models/task.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PanelModelAdapter());
  Hive.registerAdapter(TaskItemAdapter());
  await Hive.openBox<PanelModel>(kTasksBox);
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
