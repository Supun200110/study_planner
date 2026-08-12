import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/models/notification_model.dart';
import 'package:study_planner/services/database/assignment_service.dart';

class NotificationService {
  final CollectionReference notificationCollection = FirebaseFirestore.instance
      .collection('notifications');
  
  Future<void> storeOverdueAssignments()async{
    try{
      final assignmentsMap = await AssignmentService().getAssignmentWithCourseName();
for(final entry in assignmentsMap.entries){
  final courseName = entry.key;
  final assignments = entry.value;

  for(final assignment in assignments){
 final QuerySnapshot snapshot= await notificationCollection.where("assignmentId",isEqualTo: assignment.id).get();

 if(snapshot.docs.isEmpty){
  if(DateTime.now().isAfter(assignment.dueDate)){
    final NotificationModel notificationData = NotificationModel(
      assignmentId: assignment.id, 
      assignmentName: assignment.name, 
      courseName: courseName, 
      description:assignment.description, 
      dueDate: assignment.dueDate, 
      timePassed: "Overdue"
      );
      await notificationCollection.add(notificationData.toJson());
  }
 }
  }
}
      
    }catch(error){
      print(error);
    }
  }
  Future<List<NotificationModel>> getNotifications()async{
    try{

     final QuerySnapshot snapshot =  await notificationCollection.get();
     return snapshot.docs.map((doc)=>NotificationModel.fromJson(doc.data()as Map<String,dynamic>)).toList();
    }catch(error){
      print(error);
      return[];
    }
  }

}
