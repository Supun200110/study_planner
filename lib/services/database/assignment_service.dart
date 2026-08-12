import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/models/assignment_model.dart';

class AssignmentService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  Future<void> createAssigment(String courseId, Assignment assignment) async {
    try {
      final Map<String, dynamic> data = assignment.toJson();

      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection("assignment");
      DocumentReference docRef = await assignmentCollection.add(data);
      await docRef.update({'id':docRef.id});

      print("Assignment created successfully with ID :${docRef.id}");
    } catch (error) {
      print("Error creating assignment :$error");
    }
  }
}
