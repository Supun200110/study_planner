import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  Future<String> uploadFileToSupabase({
    required File noteImage,
    required String courseId,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Create a path using the courseId to organize images
      final filePath = '$courseId/$fileName';
      
      // Upload the file to Supabase storage
      await supabase.storage.from('my-bucket').upload(filePath, noteImage);
      
      // Get the public URL of the uploaded image
      final String publicUrl = supabase.storage
          .from('my-bucket')
          .getPublicUrl(filePath);
          
      return publicUrl;
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }
}