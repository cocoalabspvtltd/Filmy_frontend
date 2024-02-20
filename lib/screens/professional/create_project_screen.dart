import 'dart:io';

import 'package:film/screens/homescreens/home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {

  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController projectNameControl = TextEditingController();
  TextEditingController typeControl = TextEditingController();
  TextEditingController durationControl = TextEditingController();
  TextEditingController directorControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Project"),
      ),
        body: SingleChildScrollView(
          child: Stack(
              children: [
                ClipPath(
                  clipper: ClippingClass(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*4/7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ Color(0xFF4DD0E1),
                          Color(0xFF4DD0E1),],
                      ),
                    ),
                  ),
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
                        child: _image != null
                            ? Container(
                          height: 100,
                          width: 200,
                          margin: EdgeInsets.only(
                            top: 13.00,
                          ),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.fill,
                          ),
                        )
                            : Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 1,
                          margin: EdgeInsets.only(
                            top: 13.00,),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Text("Upload Image",style: TextStyle(color: Colors.grey),),
                              Spacer(),
                              Icon(
                                Icons.file_present_rounded,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 12,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Padding(
                        padding: const EdgeInsets.only(right: 76,left: 76,top: 20),
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _validate();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: Center(
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  fontSize: 23,
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

    //   if (formatAndValidate.validateName(project_name) != null) {
    //     return toastMessage(formatAndValidate.validateName(project_name));
    //   }  else if (formatAndValidate.validateName(project_type) != null) {
    //     return toastMessage("Enter valid type");
    //   } else if (formatAndValidate.validateName(college_city) != null) {
    //     return toastMessage(formatAndValidate.validateName(college_city));
    //   }else if (_selectedState == null) {
    //     return toastMessage("Please select State");
    //   } else if (formatAndValidate.validateName(name) != null) {
    //     return toastMessage(formatAndValidate.validateName(name));
    //   }else if (formatAndValidate.validateEmailID(email) != null) {
    //     return toastMessage(formatAndValidate.validateEmailID(email));
    //   }else if (formatAndValidate.validatePhoneNo(phone) != null) {
    //     return toastMessage(formatAndValidate.validatePhoneNo(phone));
    //   }
    //   return
    //     await _signUp(college_name,college_code,college_email,college_phone,college_address,college_city,_selectedState!,name,email,phone);
    // }
  }
}
