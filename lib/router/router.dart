import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/pages/add_new_course.dart';
import 'package:study_planner/pages/home_page.dart';

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
        name:"add_new_course",
        builder: (context, state) {
          return  AddNewCourse();
        },
      )
    ],
  );
}
