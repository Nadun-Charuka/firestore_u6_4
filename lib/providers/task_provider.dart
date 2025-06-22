import 'dart:async';

import 'package:firestore_u6_4/model/task_model.dart';
import 'package:firestore_u6_4/services/task_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late TaskFirestoreService api;
  @override
  FutureOr<List<Task>> build() async {
    api = TaskFirestoreService();
    return api.getTasks();
  }

  Future<void> addTask(String name) async {
    final task = Task(
      id: "",
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isUpdated: false,
    );
    final created = await api.createTask(task);
    state = AsyncData([...state.value!, created]);
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  () => TaskNotifier(),
);
