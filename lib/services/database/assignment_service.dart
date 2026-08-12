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

  Stream <List<Assignment>> getAssignments (String courseId){
    try{
       final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection("assignment");
          return assignmentCollection.snapshots().map((snapshot){
            return snapshot.docs.map((doc)=>Assignment.fromJson(doc.data()as Map<String,dynamic>)).toList();
          });
    }catch(error){
      print("Error fetching assignments: $error");
      return Stream.empty();
      
    }
  }
  
  Future <Map<String,List<Assignment>>> getAssignmentWithCourseName()async{
    try{
     final QuerySnapshot snapShot = await courseCollection.get();
     final Map<String,List<Assignment>> assignmentMap = {};

     for(final doc in snapShot.docs){
      final String courseId= doc.id;
      final List<Assignment> assignments = await getAssignments(courseId).first;

      assignmentMap[doc["name"]]=assignments;
     }
     
     return assignmentMap;
    }
    catch(error){
      print("Error fetching assignments: $error");
      return {};
    }
  }


  
}
