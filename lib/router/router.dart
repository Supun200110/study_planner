import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/models/assignment_model.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/models/note_model.dart';
import 'package:study_planner/pages/add_new_assignment.dart';
import 'package:study_planner/pages/add_new_course.dart';
import 'package:study_planner/pages/home_page.dart';
import 'package:study_planner/pages/add_new_note.dart';
import 'package:study_planner/pages/notifications_page.dart';
import 'package:study_planner/pages/single_assignment.dart';
import 'package:study_planner/pages/single_course_page.dart';
import 'package:study_planner/pages/single_note_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: '/',
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(body: Center(child: Text('Page not found'))),
      );
    },

    routes: [
      //homepage
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: '/add_new_course',
        name: "add_new_course",
        builder: (context, state) {
          return AddNewCourse();
        },
      ),
      GoRoute(
        path: "/single_course",
        name: "single_course",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return SingleCoursePage(course: course);
        },
      ),
       GoRoute(
        path: "/add_new_note",
        name: "add_new_note",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return AddNewNote(course: course);
        },
      ),
       GoRoute(
        path: "/add_new_assignment",
        name: "add_new_assignment",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return AddNewAssignment(course: course);
        },
      ),
      GoRoute(
        path: "/single_note",
        name: "single note",
        builder: (context, state) {
          final Note note = state.extra as Note;
          return SingleNoteScreen(note: note);
        },
        ),
        GoRoute(
        path: "/single_assignment",
        name: "single assignment",
        builder: (context, state) {
          final Assignment assignment = state.extra as Assignment;
          return SingleAssignmentScreen(assignment: assignment);
        },
        ),
        GoRoute(
          path: "/notifications",
          name: "notifications",
          builder: (context, state) {
            return NotificationsPage();
          },
          ),
    ],
  );
}
