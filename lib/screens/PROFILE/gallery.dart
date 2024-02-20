

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/user.dart';
import 'package:film/widgets/app_dialogs.dart';
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
  void initState() {
    super.initState();

    _galleryImages();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _galleryImages();
    });
  }

  @override
  List<XFile> _images = [];
  List gallery = [];
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
      AppDialogs.loading();
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
        toastMessage("Gallery images uploaded successfully");
        print('Gallery images uploaded successfully');
        AppDialogs.closeDialog();
        // Refresh the page after uploading images
        refreshGallery();
      } else {
        print('Failed to upload gallery images');
        // Handle error response
      }
    }
  }

  Future<void> _galleryImages() async {
    AppDialogs.loading();
    var uri = Uri.parse('https://2a67-117-193-46-94.ngrok-free.app/api/users/user-gallery');
    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${UserDetails.apiToken}',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        gallery = jsonResponse['gallery'];
      });
      print('Gallery images fetched successfully > $gallery');
      AppDialogs.closeDialog();
      // Handle success response
    } else {
      print('Failed to fetch gallery images');
      // Handle error response
    }
  }

  // New function to refresh the gallery
  void refreshGallery() {
    setState(() {
      _images = [];
      gallery = [];
    });
    _galleryImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Your gallery'),
      ),
      body: gallery.isEmpty
          ? ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.file(File(_images[index].path));
        },
      )
          : ListView.builder(
        itemCount: gallery.length,
        itemBuilder: (context, index) {
          final image = gallery[index]['images'];
          return Row(
            children:[ Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(height: 200,width: 200,
                  child: Image.network(
                    'http://2a67-117-193-46-94.ngrok-free.app/storage/$image',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Add logic here to delete the image
                  // You can use the image ID or other unique identifier
                },
              ),
          ]
          );

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
