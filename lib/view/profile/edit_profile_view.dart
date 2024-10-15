import 'dart:io';
import 'package:brainshare/services/auth/auth_user.dart';
import 'package:brainshare/services/profile/profile_update_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../utils/profile_image_circular_widget.dart';

class EditProfileView extends StatefulWidget {
  final AuthUser authUser;

  const EditProfileView({super.key, required this.authUser});

  @override
  State<StatefulWidget> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? imageFile;
  File? cvFile;
  late final TextEditingController _status;
  late final TextEditingController _bio;
  late final TextEditingController _cvURL;

  @override
  void initState() {
    super.initState();
    _status = TextEditingController(text: widget.authUser.status);
    _bio = TextEditingController(text: widget.authUser.bio);
    _cvURL = TextEditingController(text: widget.authUser.cvURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: selectImage,
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: imageFile != null
                    ? profileWidget(file: imageFile, width: 120, height: 120, size: 50)
                    : profileWidget(photoURL: widget.authUser.photoURL, width: 120, height: 120, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: selectImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                  minimumSize: const Size(60, 40),
                ),
                child: const Text('Edit Photo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.authUser.username,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _status,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Enter your status",
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Bio:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _bio,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Enter your biography",
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'CV:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.grey),
                        onPressed: selectCV,
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_status.text.isNotEmpty &&_bio.text.isNotEmpty) {
                            await ProfileUpdateService().updateStatus(_status.text);
                            await ProfileUpdateService().updateBio(_bio.text);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    final file = result.files.first;

    await ProfileUpdateService().updatePhotoURL(File(file.path!));

    final updatedUser = await ProfileUpdateService().getProfile();

    setState(() {
      imageFile = File(file.path!);
      widget.authUser.updateUser(updatedUser);
    });
  }

  Future<void> selectCV() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final file = result.files.first;

    await ProfileUpdateService().updateCvURL(File(file.path!));

  }
}
