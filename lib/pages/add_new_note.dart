import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_planner/models/course_model.dart';
import 'package:study_planner/models/note_model.dart';
import 'package:study_planner/services/database/note_service.dart';
import 'package:study_planner/utils/util_functions.dart';
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
  
   void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try{
        final Note note = Note(
          id: "",
          title: _titleController.text,
          description: _descriptionController.text,
          section: _selectionController.text,
          references: _referencesController.text,
          imageUrl: _selectedImage?.path,
          imageData: _selectedImage != null ? File(_selectedImage!.path) : null,
        );
        await NoteService().createNote(
          note: note,
          coureId: widget.course.id,
        );
        showSnakbar(context: context, text: "Note added successfully");
        await Future.delayed(Duration(seconds: 2));
       GoRouter.of(context).pop();
      }catch(error){
        showSnakbar(context: context, text: "Error adding note: $error");
      }
    }
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
                    ),),

                    const SizedBox(height: 20),
                    CoustomButton(
                      text: "Submit Note", 
                      onPressed: ()=>_submitForm(context),
                      ),

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
