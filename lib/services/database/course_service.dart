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

  //get all courses from the database
  Stream<List<Course>> get courses {
    try {
      return courseCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc)=> Course.fromJson(doc.data() as Map<String, dynamic>)).toList();
      });
    } catch (e) {
      print("Error getting courses: $e");
      return Stream.empty();
    }
  }
  Future<List<Course>> getCourse()async{
    try{
      final QuerySnapshot snapShot = await courseCollection.get();
      return snapShot.docs
          .map((doc) {
            return Course.fromJson(doc.data() as Map<String, dynamic>);
          })
          .toList();
    }
    catch(error){
      print("Error getting courses: $error");
      return [];
    }
  }
}
