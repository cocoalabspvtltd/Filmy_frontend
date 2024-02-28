

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

import '../../network/apis.dart';

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
  String galleryid =""
;  Future<void> _pickImages() async {
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
      var uri = Uri.parse('${Apis.url}${Apis.usergallery}');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer ${User_Details.apiToken}';
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
   // AppDialogs.loading();
    var uri = Uri.parse('${Apis.url}${Apis.fetchgallery}');
    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer ${User_Details.apiToken}',
      'Content-Type': 'application/json',
    });
print("respon->${response.body}");
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        gallery = jsonResponse['gallery'];
     //   galleryid = jsonResponse["gallery"]["id"];
      });
      print('Gallery images fetched successfully > $gallery');
      AppDialogs.closeDialog();
      // Handle success response
    } else {

      print('Failed to fetch gallery images');
      // Handle error response
    }
  }
  Future<void> _uploadImagesdelete(int id) async {

      print("obje>a${id}");
print('${Apis.url}'
'api/users/galleries/${id}/delete');
      var uri = Uri.parse('${Apis.url}'
          'api/users/galleries/${id}/delete');
      var request = http.MultipartRequest('DELETE', uri);
      request.headers['Authorization'] = 'Bearer ${User_Details.apiToken}';
      request.headers['content-type'] = 'application/json';

      var response = await request.send();
      String responseText = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseText);
      bool status = jsonResponse['status'];
      String message = jsonResponse['message'];
      if (status == true) {
        toastMessage("Gallery images deleted successfully");
        print('Gallery images uploaded successfully');
        AppDialogs.closeDialog();
        // Refresh the page after uploading images
        refreshGallery();
      } else {
        toastMessage("Failed to delete gallery images");
        print('Failed to delete gallery images');
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

      body: gallery.isEmpty
          ?
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.file(File(_images[index].path));
        },
      )

      // ListView.builder(
      //   itemCount: _images.length,
      //   itemBuilder: (context, index) {
      //     return Image.file(File(_images[index].path));
      //   },
      // )
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: gallery.length,

        itemBuilder: (context, index) {
          final image = gallery[index]['images'];
          return Row(
              children:[ Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(height: MediaQuery.of(context).size.height * 0.27,
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: Image.network(
                      '${User_Details.userbaseur}/$image',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async{
                    await _uploadImagesdelete(gallery[index]['id']);
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
