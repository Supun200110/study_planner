import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Assignment {
  final String id;
  final String name;
  final String description;
  final String duration;
  final DateTime dueDate;
  final TimeOfDay dueTime;

  Assignment({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.dueDate,
    required this.dueTime,
  });
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id']??"",
      name: json['name']??"",
      description: json['description']??"",
      duration: json['duration']??"",
      dueDate: (json['dueDate']as Timestamp).toDate(),
      dueTime: TimeOfDay.fromDateTime((json["dueTime"]as Timestamp).toDate()),
      
    );
  } 
  Map<String, dynamic> toJson() {
    return{
     "name": name,
     "description":description,
     "duration": duration,
     "dueDate": Timestamp.fromDate(dueDate),
     "dueTime": Timestamp.fromDate(DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime.hour,
      dueTime.minute,
     )),
    };
  }
  
}
