import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/constants/colors.dart';
import 'package:study_planner/models/notification_model.dart';
import 'package:study_planner/services/database/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Future<List<NotificationModel>> _getNotifications()async{
     return NotificationService().getNotifications();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: FutureBuilder(
        future: _getNotifications(), 
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text("Error fetching notifications"),);
          }
          else if (!snapshot.hasData == null || snapshot.data!.isEmpty){
            return Center(child: Text("No notifications yet"),);
          }
          else{
            final notifications = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index){
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.assignmentName),
                  subtitle:  Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course: ${notification.courseName}',
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        Text('Assignment: ${notification.assignmentName}',
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        Text(
                          'Due Date: ${DateFormat.yMMMd().format(notification.dueDate)}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                         Text(
                          'Time: ${(notification.dueDate.difference(DateTime.now()).inHours).toString()} hours',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                );
              },
            );
          }
          
        
        },
        ),
    );
  }
}