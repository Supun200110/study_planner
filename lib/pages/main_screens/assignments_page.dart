import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/constants/colors.dart';
import 'package:study_planner/models/assignment_model.dart';
import 'package:study_planner/services/database/assignment_service.dart';
import 'package:study_planner/services/database/notification_service.dart';
import 'package:study_planner/widgets/countdown_timer.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  Future<Map<String, List<Assignment>>> _fetchAssignments() async {
    return await AssignmentService().getAssignmentWithCourseName();
  }

  Future<void> _checkAndStoreOverdueAssignments() async{
      await NotificationService().storeOverdueAssignments();

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStoreOverdueAssignments();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push("/notifications");
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments found'));
          }
          final assignmentMap = snapshot.data!;
          return ListView.builder(
            itemCount: assignmentMap.keys.length,
            itemBuilder: (context, index) {
              final courseName = assignmentMap.keys.elementAt(index);
              final assignments = assignmentMap[courseName]!;
              return ExpansionTile(
                title: Text(
                  courseName,
                  style: TextStyle(fontSize: 18, color: darkGreen),
                ),
                children: assignments.map((assignment) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal:16,vertical:10),
                    title: Text(
                      assignment.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)},', style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),),
                        Text(
                          'Duration: ${assignment.duration} hours',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                        Text('Description: ${assignment.description}', style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white38,
                          ),),
                        CountdownTimer(dueDate: assignment.dueDate),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
