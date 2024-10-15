import 'package:flutter/material.dart';
import 'dart:io';

Widget profileWidget({File? file, String? photoURL, required double width, required double height, required double size}) {
  return ClipOval(
    child: SizedBox(
      width: width,
      height: height,
      child:
      photoURL == "" ? Container(
        width: width,
        height: height,
        color: Colors.black12,
        child: Icon(Icons.person, color: Colors.white, size: size),
      )
          : file != null ? Image.file(file) : Image.network(photoURL!, fit: BoxFit.cover),
    ),
  );
}
