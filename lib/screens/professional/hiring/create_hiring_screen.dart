import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:film/bloc/professionalBloc/hiring_bloc.dart';
import 'package:film/models/common.dart';
import 'package:film/models/skillresponse.dart';
import 'package:film/network/apis.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:film/utils/user.dart';
import 'package:film/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CreateHiringScreen extends StatefulWidget {
  final String ProjectId;
  const CreateHiringScreen({Key? key, required this.ProjectId})
      : super(key: key);

  @override
  State<CreateHiringScreen> createState() => _CreateHiringScreenState();
}

class _CreateHiringScreenState extends State<CreateHiringScreen> {
  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController titleControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();
  TextEditingController experienceControl = TextEditingController();
  TextEditingController openingsControl = TextEditingController();
  TextEditingController salaryControl = TextEditingController();

  HiringBloc _bloc = HiringBloc();
  List<Skills> Skillsmulti = [];
  Map<String, String> headers = {
    'Authorization': 'Bearer ${User_Details.apiToken}',
    'Accept': 'application/json', // Assuming JSON content type
  };
  String title = "";
  List<int> selectedOptionsIds = [];
  List<dynamic> skilList = [];
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchJuryMembers();
    });
  }

  void _fetchJuryMembers() async {
    final response = await http
        .get(Uri.parse('${Apis.url}${Apis.userSkillList}'), headers: headers);
    final jsonResponse = json.decode(response.body);
    print("jury->${response.body}");
    if (jsonResponse["skills"] != []) {
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
    print("Id-->${widget.ProjectId}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Hiring"),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
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
            padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: titleControl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter title',
                    ),
                    onChanged: (value) {
                      print('The entered text is: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: descriptionControl,
                    maxLines: 8,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter description',
                        fillColor: Colors.white),
                    onChanged: (value) {
                      print('The entered text is: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Skills",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "*",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white
                  ),
                  child: MultiSelectDialogField<Skills>(
                    items: Skillsmulti.map((member) => MultiSelectItem<Skills>(
                        member, member.name.toString())).toList(),
                    initialValue: selectedOptionsIds.map((id) {
                      return Skillsmulti.firstWhere(
                          (element) => element.id == id);
                    }).toList(),
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
                      chipColor: Colors.cyan,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      // Customize input decoration
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey), // Remove underline
                      color: Colors.white, // Change fill color
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Experience",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: experienceControl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter experience',
                        fillColor: Colors.white),
                    onChanged: (value) {
                      print('The entered text is: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Openings",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: openingsControl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter openings',
                        fillColor: Colors.white),
                    onChanged: (value) {
                      print('The entered text is: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Salary",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: salaryControl,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter salary',
                        fillColor: Colors.white),
                    onChanged: (value) {
                      print('The entered text is: $value');
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
    var title = titleControl.text;
    var description = descriptionControl.text;
    var experience = experienceControl.text;
    var opening = openingsControl.text;
    var salary = salaryControl.text;

    if (formatAndValidate.validateName(title) != null) {
      return toastMessage(formatAndValidate.validateName(title));
    } else if (formatAndValidate.validateAddress(description) != null) {
      return toastMessage("Please enter description");
    } else if (selectedOptionsIds.isEmpty) {
      return toastMessage("Please select skills");
    }
    if (experience == null) {
      return toastMessage("Please enter experience");
    }
    if (opening == null) {
      return toastMessage("Please enter opening");
    }
    if (salary == null) {
      return toastMessage("Please enter salary");
    }

    return await _createHiring(title,   selectedOptionsIds,description, experience, opening, salary,widget.ProjectId);
  }
  _createHiring(String title, List<int> interestsids, description, experience, opening,
      salary,prjid) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _bloc.addHiring(
         title,interestsids, description, experience, opening,
        salary,prjid
    );
  }

}
