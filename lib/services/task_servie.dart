import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //create

  Future<TaskModel?> createTask(TaskModel task) async {
    try {
      final taskMap = task.toMap();
      await _taskCollection.doc(task.id).set(taskMap);

      return task;
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  //getall

  Stream<List<TaskModel>> getAllTasks() {
    try {
      String? userId = _auth.currentUser?.uid;
      return _taskCollection

          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return TaskModel.fromJson(doc);
        }).toList();
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      throw (e);
    }
  }

  //update

  Future<void> updateTask(TaskModel task) async {
    try {
      final taskMap = task.toMap();
      await _taskCollection.doc(task.id).update(taskMap);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

//delete

  Future<void> deleteTask(String? id) async {
    try {
      await _taskCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
