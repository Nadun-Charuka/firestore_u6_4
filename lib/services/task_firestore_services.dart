import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_u6_4/model/task_model.dart';
import 'package:flutter/material.dart';

class TaskFirestoreServices {
  //reference to the firestore Task collection
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String name) async {
    try {
      final task = Task(
        id: "",
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUpdated: false,
      );
      final Map<String, dynamic> data = task.toJson();
      await _taskCollection.add(data);
      debugPrint("Task added sucessfully");
    } catch (e) {
      debugPrint("Error in Adding Task $e");
    }
  }
}
