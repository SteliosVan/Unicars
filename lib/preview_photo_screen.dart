import 'dart:io';
import 'package:flutter/material.dart';
// Optional Firebase imports (if you're using Firebase)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'edit_profile_screen.dart';


class PreviewPhotoScreen extends StatelessWidget {
  final String imagePath;

  const PreviewPhotoScreen({super.key, required this.imagePath});

    Future<void> _uploadAndSave(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No user logged in");

    final file = File(imagePath);
    if (!await file.exists()) throw Exception("Image file does not exist");

    final cloudName = 'df9vs1xxf';
    final uploadPreset = 'unicars';

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath('file', file.path,
        filename: path.basename(file.path),
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = json.decode(responseBody);

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: ${data['error']['message']}');
    }

    final imageUrl = data['secure_url'];

    // Save to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  'profile_pic': imageUrl,
}, SetOptions(merge: true));

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditProfile()),
      );
    }

  } catch (e) {
    debugPrint('Error uploading image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to upload image')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),

          // Bottom buttons
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.check_circle, size: 32),
              onPressed: () => _uploadAndSave(context),
            ),
          ),
        ],
      ),
    );
  }
}
