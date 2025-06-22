import 'package:firestore_u6_4/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new Task"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter a task name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(taskProvider.notifier)
                  .addTask(controller.text.trim());
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: taskAsync.when(
          data: (tasks) => ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
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
          _showAddTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
