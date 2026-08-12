import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner/models/note_model.dart';
import 'package:study_planner/services/cloud_storage/store_images.dart';

class NoteService {
   final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection("courses");

  Future <void> createNote({required String coureId , required Note note})async{
    try{
    String? imageUrl;

    if(note.imageData != null){
      imageUrl = await StorageService().uploadFileToSupabase(
        noteImage: note.imageData!, 
        courseId: coureId,
        );
    }
    final Note newNote = Note(
      id: "",
      title: note.title,
      description: note.description,
      section: note.section,
      references: note.references,
      imageUrl: imageUrl,
      imageData: note.imageData,
    );
    final DocumentReference docRef=await courseCollection.doc(coureId).collection("notes").add(newNote.toJson());
    final String noteId = docRef.id;

    await docRef.update({
      "id": noteId,
    });
    print("Note created with ID : $noteId");
    }catch(error){
      print("Error creating note : $error");
      throw Exception("Failed to create note : $error");
    }
    
  }

}