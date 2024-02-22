import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:film/bloc/professionalBloc/project_bloc.dart';
import 'package:film/models/common.dart';
import 'package:film/models/skillresponse.dart';
import 'package:film/network/apis.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';


class CreateHiringScreen extends StatefulWidget {
  const CreateHiringScreen({Key? key}) : super(key: key);

  @override
  State<CreateHiringScreen> createState() => _CreateHiringScreenState();
}

class _CreateHiringScreenState extends State<CreateHiringScreen> {

  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController titleControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  TextEditingController typeControl = TextEditingController();
  TextEditingController experienceControl = TextEditingController();
  TextEditingController openingsControl = TextEditingController();

  ProjectBloc _bloc =ProjectBloc();
  List<Skills> Skillsmulti = [];
  Map<String, String> headers = {
    'Authorization': 'Bearer ${User_Details.apiToken}',
    'Accept': 'application/json', // Assuming JSON content type
  };
  String title="";
  List<int> selectedOptionsIds = [];
  List<dynamic> skilList=[];
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchJuryMembers();

    });
  }
  void _fetchJuryMembers() async {

    final response = await http.get(Uri.parse('${Apis.url}${Apis.userSkillList}'),
        headers: headers
    );
    final jsonResponse = json.decode(response.body);
    print("jury->${response.body}");
    if (jsonResponse["skills"]!=[]) {


      print("jury->${jsonResponse}");
      skilList = jsonResponse['skills'];
      print("jury->${skilList}");

      setState(() {
        Skillsmulti = skilList.map((e) => Skills.fromJson(e)).toList();
      });
    } else {
      // If API call fails, handle the error
      throw Exception('Failed to load jury members');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Hiring"),
      ),
      body: SingleChildScrollView(
        child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Colors.cyan,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [ Color(0xFF4DD0E1),
                //       Color(0xFF4DD0E1),],
                //   ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Title",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Colors.white,),
                      child: TextField(controller: titleControl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter title',

                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Description",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(controller: descriptionControl,
                        maxLines: 10,
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
                    Text("Experience",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(controller:experienceControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter experience',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Openings",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller:openingsControl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter openings',
                            fillColor: Colors.white
                        ),
                        onChanged: (value) {
                          print('The entered text is: $value');
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text("Skills",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    SizedBox(height: 6,),
                    MultiSelectDialogField<Skills>(
                      items: Skillsmulti.map((member) =>
                          MultiSelectItem<Skills>(
                              member, member.name.toString())).toList(),
                      initialValue: Skillsmulti,
                      selectedColor: Colors.cyan,
                      unselectedColor: Colors.black,
                      confirmText: Text(
                        'Submit',
                        style: TextStyle(color: Colors.black),
                      ),
                      cancelText: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      title: Text('Select skills'),
                      buttonText: Text('Select skills'),
                      onConfirm: (values) {
                        setState(() {
                          selectedOptionsIds =
                              values.map<int>((member) => member.id!).toList();
                          print("Options: $selectedOptionsIds");
                        });
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        chipColor: primaryColor,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration( // Customize input decoration
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey), // Remove underline
                        color: Colors.white, // Change fill color
                      ),
                    ),
                    SizedBox(height: 6,),
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
                              "Create",
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



  _validate() async {
    var project_name = titleControl.text;
    var project_type = typeControl.text;
    var project_duration = experienceControl.text;
    var project_director = openingsControl.text;
    var project_description = descriptionControl.text;
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
      await _createProject(project_name,project_type,project_duration,project_director,project_description);
  }


  Future _createProject(
      String name,
      String type,
      String duration,
      String director,
      String description,
      ) async {
    var formData = FormData();
    formData.fields..add(MapEntry("project_name",name));
    formData.fields..add(MapEntry("type",type));
    formData.fields..add(MapEntry("description", description));
    if(duration.isNotEmpty) formData.fields..add(MapEntry("duration", duration));
    if(director.isNotEmpty) formData.fields..add(MapEntry("director", director));

    _bloc.addProject(formData).then((value) {
      Get.back();
      CommonResponse response = value;
      if (response.statusCode == 200) {
        toastMessage("${response.message}");
        Get.to(() => PHomeScreen());
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

