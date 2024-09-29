import 'package:todolisthive/panel.dart';
import 'package:todolisthive/models/task.dart';
import 'package:hive/hive.dart';

class TaskController {
  static List<PanelModel> panels = [];

  static Future<void> loadPanels() async {
    var taskBox = Hive.box<PanelModel>(kTasksBox);
    panels = taskBox.values.toList();
  }

  static Future<void> addPanel(PanelModel panel) async {
    var taskBox = Hive.box<PanelModel>(kTasksBox);
    panels.add(panel);
    await taskBox.add(panel);
  }

  static Future<void> deletePanel(PanelModel panel) async {
    panels.remove(panel);
    await panel.delete();
  }

  static Future<void> updatePanel(PanelModel panel) async {
    await panel.save();
  }

  static void editTask(PanelModel panel, TaskItem task, String newDescription) {
    task.description = newDescription;
    updatePanel(panel);
  }

  static void deleteTask(PanelModel panel, TaskItem task) {
    panel.items.remove(task);
    updatePanel(panel);
  }
}
