import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isUpdated;

  Task({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isUpdated,
  });

  factory Task.fromJson(Map<String, dynamic> doc, String id) {
    return Task(
      id: id,
      name: doc['name'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
      isUpdated: doc['isUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isUpdated': isUpdated,
    };
  }

  Task copyWith(
      {String? id,
      String? name,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? isUpdated}) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }
}
