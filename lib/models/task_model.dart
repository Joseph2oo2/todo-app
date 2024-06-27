import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel{
   String? id;
   String? title;
   String? body;
   DateTime? createdAt;
   int? status;

   TaskModel({this.id,this.title,this.body,this.createdAt,this.status});


   factory TaskModel.fromJson(DocumentSnapshot json){
     Timestamp? timestamp = json['createdAt'] as Timestamp?;
     DateTime? createdAt = timestamp?.toDate();
     return TaskModel(
       id:json.id,
       title: json['title']as String?,
       body: json['body']as String?,
       createdAt: createdAt,
       status: json['status']as int?
     );
   }

   Map<String,dynamic> toMap(){
     return{
       'id':id,
       'title':title,
       'body':body,
       'createdAt':createdAt,
       'status':status
     };
}

}