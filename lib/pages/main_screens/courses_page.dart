import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/constants/colors.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/services/database/assignment_service.dart';
import 'package:study_planner/services/database/course_service.dart';
import 'package:study_planner/services/database/note_service.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  Future<Map<String,dynamic>> _fetchData()async{
    try{
      final courses = await CourseService().getCourse();
      final assignmentsMap = await AssignmentService().getAssignmentWithCourseName();

      final notesMap = await NoteService().getNotesByCourseName();

      return{
        "courses":courses,
        "assignmentsMap":assignmentsMap,
        "notesMap":notesMap,
      };
    }catch(error){
      print("Error fetching data: $error");
      return {
        "courses":[],
        "assignmentsMap":{},
        "notesMap":{},
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: FutureBuilder(
        future: _fetchData(), 
        builder: (context , snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          else if(!snapshot.hasData || snapshot.data== null){
            return Center(
              child: Text("No courses found"),
            );
          }
          final courses = snapshot.data!["courses"] as List<Course>? ?? [];
          final assignmentMap = snapshot.data!["assignmentsMap"] as Map<String,dynamic>? ?? {};
          final notesMap = snapshot.data!["notesMap"] as Map<String,dynamic>? ?? {};

          if(courses.isEmpty){
            return Center(child: Text("No courses found"),);
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context , index){
              final course = courses[index];
              final courseAssignments =
                  assignmentMap[course.name] ?? [];
              final courseNotes = notesMap[course.name] ?? [];

              return Card(
                
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 10),
                        Text('Description: ${course.description}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white60)),
                        const SizedBox(height: 10),
                        Text('Duration: ${course.duration}',
                            style: TextStyle(fontSize: 14, color: Colors.lightGreen)),
                        const SizedBox(height: 5),
                        Text('Schedule: ${course.schedule}',
                            style: TextStyle(fontSize: 14, color: Colors.lightGreen)),
                        const SizedBox(height: 5),
                        Text('Instructor: ${course.instructor}',
                            style: TextStyle(fontSize: 14, color: Colors.lightGreen)),
                        const SizedBox(height: 20),

                        if(courseAssignments.isNotEmpty)...[
                          Text("Assignments",style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: courseAssignments.map<Widget>((assignment){
                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: ListTile(
                                  title: Text(assignment.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)}'),
                                onTap: (){
                                  GoRouter.of(context).push("single_assignment",extra: assignment);
                                },
                              
                                ),
                              );
                            }).toList(),
                          )
                        ],
                         if(courseNotes.isNotEmpty)...[
                          Text("Notes",style: TextStyle(fontWeight: FontWeight.w500),),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: courseNotes.map<Widget>((note){
                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: ListTile(
                                  title: Text(note.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),

                                         onTap: (){
                                  GoRouter.of(context).push("single_note",extra: note);
                                },
                                ),
                              );
                            }).toList(),
                          )
                        ]
                    ]
                  ),
                ),
              );             
                  
            }
            );
        }
      )
    );
  }
}
