import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/models/common.dart';
import 'package:film/network/apis.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:film/utils/user.dart';
import 'package:film/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/app_dialogs.dart';
class ApplyHiringScreen extends StatefulWidget {
  const ApplyHiringScreen({Key? key, required this.id}) : super(key: key);
final String id;
  @override
  State<ApplyHiringScreen> createState() => _ApplyHiringScreenState();
}

class _ApplyHiringScreenState extends State<ApplyHiringScreen> {
  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController commentControl = TextEditingController();

  @override

  Future<void> Applyhiring() async {
    AppDialogs.loading();
    var url = Uri.parse('${Apis.url}api/applications/${widget.id}/store');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${User_Details.apiToken}', // Optional, if you need to include an authorization token
    };
    var body = jsonEncode({
      'comments': commentControl.text,
      // Add more key-value pairs as needed
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      toastMessage("Request Send Successfully");
      AppDialogs.closeDialog();
      Get.back();
      print('Request successful');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Apply"),
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
              padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey), // Set the border color here
                        borderRadius: BorderRadius.circular(10), // Optional: Adjust border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,bottom: 15,top: 15),
                        child: Text("${User_Details.userName}",style: TextStyle(fontSize: 16,color: Colors.grey[800]),),
                      )
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Phone",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey), // Set the border color here
                        borderRadius: BorderRadius.circular(10), // Optional: Adjust border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,bottom: 15,top: 15),
                        child: Text("${User_Details.userMobile}",style: TextStyle(fontSize: 16,color: Colors.grey[800]),),
                      )
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey), // Set the border color here
                        borderRadius: BorderRadius.circular(10), // Optional: Adjust border radius
                      ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,bottom: 15,top: 15),
                      child: Text("${User_Details.userEmail}",style: TextStyle(fontSize: 16,color: Colors.grey[800]),),
                    )
                  ),
                  SizedBox(height: 10),

                  Text(
                    "Comment",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      controller: commentControl,
                      maxLines: 8,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter comments',
                          fillColor: Colors.white),
                      onChanged: (value) {
                        print('The entered text is: $value');
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 40,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async{await Applyhiring();},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            "Apply",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
}
