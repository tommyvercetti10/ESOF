import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<void> addFile(File file, String ref) async {
    await _storage.ref().child(ref).putFile(file);
  }

  Future<String> getURL(String ref) async {
    return await _storage.ref().child(ref).getDownloadURL();
  }

}