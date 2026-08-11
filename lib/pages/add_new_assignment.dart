import 'package:flutter/material.dart';
import 'package:study_planner/models/assignment_model.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/services/assignment_service.dart';
import 'package:study_planner/utils/util_functions.dart';
import 'package:study_planner/widgets/coustom_button.dart';
import 'package:study_planner/widgets/coustom_input.dart';

class AddNewAssignment extends StatelessWidget {
  final Course course;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _assignmentDescriptionController =
      TextEditingController();
  final TextEditingController _assignmentDurationController =
      TextEditingController();

  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  final ValueNotifier<TimeOfDay> _selectedTime = ValueNotifier<TimeOfDay>(
    TimeOfDay.now(),
  );
  AddNewAssignment({super.key, required this.course}) {
    _selectedDate.value = DateTime.now();
    _selectedTime.value = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext ctx) async {
    final DateTime? picked = await showDatePicker(
      context: ctx,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDate: _selectedDate.value,
    );
    if (picked != null && picked != _selectedDate.value) {
      _selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext ctx) async {
    final TimeOfDay? picked = await showTimePicker(
      context: ctx,
      initialTime: _selectedTime.value,
    );
    if (picked != null && picked != _selectedTime.value) {
      _selectedTime.value = picked;
    }
  }

  //Submit form
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try{
        final Assignment assignment = Assignment(
          id: "", 
          name: _assignmentNameController.text, 
          description: _assignmentDescriptionController.text, 
          duration: _assignmentDurationController.text, 
          dueDate: _selectedDate.value, 
          dueTime: _selectedTime.value
          );
          await AssignmentService().createAssigment(
            course.id, 
            assignment
            );
            showSnakbar(context: context, text: "Assignment created successfully");
            await Future.delayed(Duration(seconds: 2));
            Navigator.pop(context);
            
      }catch(error){
        print(error);
        showSnakbar(context: context, text: "Failed to add asignment");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Assignment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                //description
                const Text(
                  'Fill in the details below to add a new assignment. And start managing your study planner.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 20),
                CustomInput(
                  controller: _assignmentNameController,
                  labelText: "Assignment Name",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter the assignment name";
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _assignmentDescriptionController,
                  labelText: "Assignment Description",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter the assignment description";
                    }
                    return null;
                  },
                ),
                CustomInput(
                  controller: _assignmentDurationController,
                  labelText: "Duration(e.g.,1 hour))",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter the assignment Duration";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'Due Date and Time',
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDate,
                  builder: (context, date, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date ${date.toLocal().toString().split(" ")[0]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    );
                  },
                ),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: _selectedTime,
                  builder: (context, time, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Date ${time.format(context)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectTime(context),

                          icon: Icon(Icons.access_time),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                CoustomButton(
                  text: "Add Asignment",
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
