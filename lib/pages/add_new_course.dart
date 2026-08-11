import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/services/course_service.dart';
import 'package:study_planner/utils/util_functions.dart';
import 'package:study_planner/widgets/coustom_button.dart';
import 'package:study_planner/widgets/coustom_input.dart';

class AddNewCourse extends StatelessWidget {
  AddNewCourse({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _courseDurationController =
      TextEditingController();
  final TextEditingController _courseScheduleController =
      TextEditingController();
  final TextEditingController _courseInstructorController =
      TextEditingController();
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        final Course course = Course(
          id: "",
          name: _courseNameController.text,
          description: _courseDescriptionController.text,
          duration: _courseDurationController.text,
          schedule: _courseScheduleController.text,
          instructor: _courseInstructorController.text,
        );
        await CourseService().createNewCourse(course);
        if(context.mounted){
          showSnakbar(context: context, text:"Course added successfully");
        }
        await Future.delayed(Duration(seconds: 2));
        if(context.mounted) {
          GoRouter.of(context).go("/");
        }
      } catch (e) {
        if(context.mounted){
          showSnakbar(context: context, text:"Error adding course: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add New Course',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                //description
                const Text(
                  'Fill in the details below to add a new course.And start managing your study planner.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                CustomInput(
                  controller: _courseNameController,
                  labelText: 'Course Name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a course name';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _courseDescriptionController,
                  labelText: 'Course Description',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a course description';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _courseDurationController,
                  labelText: 'Course Duration',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the course duration';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _courseScheduleController,
                  labelText: 'Course Schedule',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the course schedule';
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _courseInstructorController,
                  labelText: 'Course Instructor',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the course instructor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CoustomButton(
                  text: "Add Course",
                  onPressed: () => _submitForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
