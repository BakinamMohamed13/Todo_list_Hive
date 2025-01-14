import 'package:flutter/material.dart';
import 'package:todolisthive/controller/controlller.dart';
import 'package:todolisthive/models/task.dart';

class ExpansionPanelItem extends StatefulWidget {
  final PanelModel panel;
  final Function(TaskItem task) onDeleteTask;
  const ExpansionPanelItem({
    super.key,
    required this.panel,
    required this.onDeleteTask,
  });

  @override
  _ExpansionPanelItemState createState() => _ExpansionPanelItemState();
}

class _ExpansionPanelItemState extends State<ExpansionPanelItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Container(
          child: ExpansionPanelList(
            dividerColor: Colors.blue,
            expandedHeaderPadding: const EdgeInsets.all(14),
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.panel.isExpanded = isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                backgroundColor: const Color.fromARGB(255, 255, 191, 191),
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  int completedTasks =
                      widget.panel.items.where((task) => task.isDone).length;
                  int totalTasks = widget.panel.items.length;

                  return ListTile(
                    contentPadding:
                        const EdgeInsets.only(top: 18, bottom: 18, left: 3),
                    title: Text(
                      widget.panel.time,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: completedTasks == totalTasks
                              ? Colors.green
                              : completedTasks == 0
                                  ? Colors.grey
                                  : Colors.blue),
                      completedTasks == totalTasks
                          ? "Completed"
                          : "$completedTasks/$totalTasks Tasks Completed",
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: widget.panel.items.map((task) {
                      return Container(
                        child: ListTile(
                          title: Text(
                            task.description,
                            style: TextStyle(
                                fontSize: 22,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              setState(() {
                                task.isDone = value!;
                                TaskController.updatePanel(widget.panel);
                              });
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showEditDialog(task);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  _deleteTask(task);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                isExpanded: widget.panel.isExpanded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(TaskItem task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Task",
            style: TextStyle(fontSize: 22),
          ),
          content: const Text(
            "Confirm to delete this task",
            style: TextStyle(fontSize: 22),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.onDeleteTask(task);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(TaskItem task) {
    final TextEditingController editingController =
        TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 238, 139),
          title: const Text(
            "Edit Task",
            style: TextStyle(fontSize: 22),
          ),
          content: TextField(
            style: const TextStyle(fontSize: 20),
            controller: editingController,
            decoration: const InputDecoration(
              hintText: "Editing",
              hintStyle: TextStyle(fontSize: 22),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(fontSize: 22)),
            ),
            TextButton(
              onPressed: () {
                if (editingController.text.isNotEmpty) {
                  setState(() {
                    TaskController.editTask(
                        widget.panel, task, editingController.text);
                    TaskController.updatePanel(widget.panel);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        );
      },
    );
  }
}
