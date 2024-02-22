import 'dart:io';
import 'package:dio/dio.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/models/common.dart';
import 'package:film/models/project_list_response.dart';
import 'package:film/screens/professional/component/project_list_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';


class EditProjectScreen extends StatefulWidget {
  final Projects details;
  const EditProjectScreen({Key? key,required this.details}) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {

  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController projectNameControl = TextEditingController();
  TextEditingController typeControl = TextEditingController();
  TextEditingController durationControl = TextEditingController();
  TextEditingController directorControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  File? _image;
  ProjectBloc _bloc =ProjectBloc();

  @override
  void initState() {
    _bloc = ProjectBloc();
    projectNameControl.text = widget.details.projectName!;
    typeControl.text = widget.details.type!;
    descriptionControl.text = widget.details.description!;
    if (widget.details.duration != null && widget.details.duration!.isNotEmpty) {
      durationControl.text = widget.details.duration!;
    }

    if (widget.details.director != null && widget.details.director!.isNotEmpty) {
      directorControl.text = widget.details.director!;
    }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(" Edit Project"),
      ),
      body: SingleChildScrollView(
        child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Colors.cyan,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Project Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Colors.white,),
                      child: TextField(controller: projectNameControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter project name',
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Type of project",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(controller: typeControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter type (film/shortfilm etc)',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Duration of project",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(controller:durationControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter duration',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Director of project",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller:directorControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter director name',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Description of project",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller:descriptionControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter description',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Poster of project",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _image != null
                              ? Container( height: 100,
                            width: 200,
                            margin: EdgeInsets.only(
                              top: 13.00,
                            ),
                                child: Image.file(
                            _image!,
                            fit: BoxFit.fill,
                          ),
                              )
                              : (widget.details.poster != null)
                              ? Container( height: 100,
                            width: 200,
                            margin: EdgeInsets.only(
                              top: 13.00,
                            ),
                                child: Image.network(
                            widget.details.posterUrl!,
                            fit: BoxFit.fill,
                          ),
                              )
                              : SizedBox.shrink(),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.camera_alt, size: 40, color: Colors.cyan),
                          ),
                          // Show the default UI when _image is null
                          if (_image == null && widget.details.poster == null)
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width * 1,
                              margin: EdgeInsets.only(top: 13.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(
                                    "Upload Image",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.file_present_rounded,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 12),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        height: 40,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            _validate();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //
            ]),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      _image = File(image.path);
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _validate() async {
    var project_name = projectNameControl.text;
    var project_type = typeControl.text;
    var project_duration = durationControl.text;
    var project_director = directorControl.text;
    var project_description = descriptionControl.text;
    var image =_image;
    if (formatAndValidate.validateName(project_name) != null) {
      return toastMessage(formatAndValidate.validateName(project_name));
    }  else if (formatAndValidate.validateName(project_type) != null) {
      return toastMessage("Enter valid type");
    }
    else if (formatAndValidate.validateAddress(project_description) != null) {
      return toastMessage("Please enter description");
    }

    if (project_duration.isNotEmpty && formatAndValidate.validateName(project_duration) != null) {
      return toastMessage("Please enter duration");
    }
    if (project_director.isNotEmpty && formatAndValidate.validateName(project_director) != null) {
      return toastMessage("Please provide director");
    }
    return
      await _editProject(project_name,project_type,project_duration,project_director,project_description,image);
  }


  Future _editProject(
      String name,
      String type,
      String duration,
      String director,
      String description,
      File? image,
      ) async {
    var formData = FormData();
    if (image != null) {
      String fileName = image?.path?.split('/')?.last ?? "";
      MultipartFile imageFile = await MultipartFile.fromFile(image.path, filename: fileName);
      formData.files.add(MapEntry(
        "poster",
        imageFile,
      ));
    }
    formData.fields..add(MapEntry("project_name",name));
    formData.fields..add(MapEntry("type",type));
    formData.fields..add(MapEntry("description", description));
    if(duration.isNotEmpty) formData.fields..add(MapEntry("duration", duration));
    if(director.isNotEmpty) formData.fields..add(MapEntry("director", director));

    _bloc.editProject(widget.details.id.toString(),formData).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.statusCode == 200) {
        toastMessage("${response.message}");
        Get.to(() => PHomeScreen(selectedIndex: 3,));
      } else {
        toastMessage("${response.message}");
      }
    }).catchError((err) {
      Get.back();
      print('${err}');
      toastMessage('Project not created');
    });

  }
}

