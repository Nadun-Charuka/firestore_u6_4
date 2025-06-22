import 'package:firestore_u6_4/model/task_model.dart';
import 'package:firestore_u6_4/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _showAddUpdateTaskDialog({Task? task}) {
    bool isEdit = (task != null);
    isEdit ? controller.text = task.name : controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: isEdit ? Text("Edit the Task") : Text("Add new Task"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: isEdit ? "" : "Enter a task name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                isEdit
                    ? await ref.read(taskProvider.notifier).updateTask(
                          task.copyWith(
                              name: controller.text.trim(),
                              updatedAt: DateTime.now(),
                              isUpdated: true),
                        )
                    : await ref.read(taskProvider.notifier).addTask(
                          controller.text.trim(),
                        );
              }
              controller.clear();
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: taskAsync.when(
          data: (tasks) => ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    tileColor: Colors.grey[900],
                    title: Text(task.name),
                    subtitle: Row(
                      children: [
                        Text(
                          DateFormat('yyyy-MM-DD kk:mm').format(task.createdAt),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Updated: ${task.isUpdated.toString()}")
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showAddUpdateTaskDialog(task: task);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            taskNotifier.deleteTask(task.id);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    )),
              );
            },
          ),
          error: (error, stackTrace) =>
              Center(child: Text("Error in displaying the tasks $error")),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUpdateTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
