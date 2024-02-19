

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import 'package:http/http.dart' as http;

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  List<XFile> _images = [];
  final dioOptions = dio.Options(
    headers: {'Authorization': 'Bearer ${UserDetails.apiToken}'},
    contentType: Headers.formUrlEncodedContentType,
    responseType: dio.ResponseType.json,
  );
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images = pickedImages;
      });
    }
  }


  Future<void> _uploadImages() async {
    if (_images.isNotEmpty) {
      var uri = Uri.parse('https://2a67-117-193-46-94.ngrok-free.app/api/users/upload_gallery');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer ${UserDetails.apiToken}';
      request.headers['content-type'] = 'application/json';
      for (var image in _images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images[]',
          image.path,

        ));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Gallery images uploaded successfully');
        // Handle success response
      } else {
        print('Failed to upload gallery images');
        // Handle error response
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Your gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.file(File(_images[index].path));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () async {
          await _pickImages();
          await _uploadImages();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}