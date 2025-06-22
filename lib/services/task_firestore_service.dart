import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_u6_4/model/task_model.dart';

class TaskFirestoreService {
  final _taskCollection = FirebaseFirestore.instance.collection('tasks');

  Future<Task> createTask(Task task) async {
    final docRef = await _taskCollection.add(task.toJson());
    final doc = await docRef.get();
    return Task.fromJson(doc.data()!, doc.id);
  }

  Future<List<Task>> getTasks() async {
    final snapshot = await _taskCollection.get();
    return snapshot.docs.map((e) => Task.fromJson(e.data(), e.id)).toList();
  }
}
