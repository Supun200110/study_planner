import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/models/course_model.dart';

class CourseService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  //add a new course to the database

  Future<void> createNewCourse(Course course) async {
    try {
      final Map<String, dynamic> data = course.toJson();

      final DocumentReference docRef = await courseCollection.add(data);

      await docRef.update({'id': docRef.id});
    } catch (e) {
      print("Error adding course: $e");
    }
  }
}
