import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? email;
  String? password;
  String? name;
  DateTime? createdAt;
  int? status;
  String? uid;

  UserModel(
      {this.email,
      this.password,
      this.name,
      this.createdAt,
      this.status,
      this.uid});

  factory UserModel.fromJson(DocumentSnapshot data) {
    return UserModel(
        email: data['email'],
        uid: data['uid'],
        name: data['name'],
        status: data['status'],
        createdAt: data['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "status": status,
      "createdAt": createdAt,
    };
  }
}
