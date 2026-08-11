import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/widgets/coustom_button.dart';
import 'package:study_planner/widgets/coustom_input.dart';

class AddNewNote extends StatefulWidget {
  final Course course;
  const AddNewNote({super.key, required this.course});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _selectionController = TextEditingController();

  final TextEditingController _referencesController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Note For Your Course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              //description
              const Text(
                'Fill in the details below to add a new note. And start managing your study planner.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInput(
                      controller: _titleController,
                      labelText: "Note Title",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Please Enter the note title";
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _descriptionController,
                      labelText: "Note Description",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Please Enter the note description";
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _selectionController,
                      labelText: "Note Section",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Please Enter the note section";
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _referencesController,
                      labelText: "Note Reference",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Please Enter the note reference books";
                        }
                        return null;
                      },
                    ),
                    const Divider(),
                    const Text(
                      'Upload Note Image , for better understanding and quick revision',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    CoustomButton(text: "Upload Note Image", onPressed: _pickImage),
                    _selectedImage!=null ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selected Image",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.file(
                            File(_selectedImage!.path),height: 200,width: double.infinity,fit:BoxFit.cover ,
                          ),
                        ),
                      ],
                    ): Text("No image selected",style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
