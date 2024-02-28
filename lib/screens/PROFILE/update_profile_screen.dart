import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:film/screens/PROFILE/gallery.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/string_formatter_and_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:http/http.dart' as http;
import '../../bloc/authBloc/auth.dart';
import '../../models/skillresponse.dart';
import '../../network/apis.dart';
import '../../utils/user.dart';
import '../homescreens/home_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String dropdownValueinterest = "Select";
  List<Skills> Skillsmulti = [];
  Map<String, String> headers = {
    'Authorization': 'Bearer ${User_Details.apiToken}',
    'Accept': 'application/json', // Assuming JSON content type
  };
  List<int> selectedOptionsIdsskills = [];
  List<int> selectedOptionsIdsinterest = [];
  List<dynamic> juryList = [];
  AuthBloc _authBloc = AuthBloc();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchUserProfileDetails();
      _fetchJuryMembers();
    });
  }
  Future<void> _fetchUserProfileDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${Apis.url}${Apis.fetchUserdetails}'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          profControl.text = jsonResponse['details']['profession'] ?? '';
          addressControl.text = jsonResponse['details']['address'] ?? '';
          experControl.text = jsonResponse['details']['years'].toString() ?? ''; // Assuming 'years' is the experience
          selectedOptionsIdsinterest =
          List<int>.from(jsonResponse['details']['interests'] ?? []);
          selectedOptionsIdsskills =
          List<int>.from(jsonResponse['details']['skills'] ?? []);
          _filePathname = jsonResponse['details']['resume'] ?? 'No file selected';
          print('File Path: $_filePath');

        });
      } else {
        throw Exception('Failed to fetch user profile details');
      }
    } catch (error) {
      print('Error fetching user profile details: $error');
    }
  }


  void _fetchJuryMembers() async {
    final response = await http
        .get(Uri.parse('${Apis.url}${Apis.userSkillList}'), headers: headers);
    final jsonResponse = json.decode(response.body);
    print("jury->${response.body}");
    if (jsonResponse["skills"] != []) {
      print("jury->${jsonResponse}");
      juryList = jsonResponse['skills'];
      print("jury->${juryList}");

      setState(() {
        Skillsmulti = juryList.map((e) => Skills.fromJson(e)).toList();
      });
    } else {
      throw Exception('Failed to load jury members');
    }
  }

  FilePickerResult? result;
  FormatAndValidate formatAndValidate = FormatAndValidate();
  TextEditingController addressControl = TextEditingController();
  TextEditingController profControl = TextEditingController();
  TextEditingController experControl = TextEditingController();

  Widget textfield({@required hintText, @required controller}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
          child: Stack(children: [
            ClipPath(
              clipper: ClippingClass(),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 4 / 7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4DD0E1),
                      Color(0xFF4DD0E1),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: textfield(
                    hintText: '${User_Details.userName}',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: textfield(
                    hintText: '${User_Details.userEmail}',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: textfield(
                    hintText: '${User_Details.userMobile}',
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey),
                    ),
                    child:   MultiSelectDialogField<Skills>(
                      items: Skillsmulti.map((member) => MultiSelectItem<Skills>(
                          member, member.name.toString())).toList(),
                      initialValue: selectedOptionsIdsinterest.map((id) {
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
                      title: Text('Select Interest'),
                      buttonText: Text('Select Interests'),
                      onConfirm: (values) {
                        setState(() {
                          selectedOptionsIdsinterest =
                              values.map<int>((member) => member.id!).toList();
                          print("Options: $selectedOptionsIdsinterest");
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
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: profControl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your profession',
                      ),
                      onChanged: (value) {
                        print('The entered text is: $value');
                      },
                    ),
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: addressControl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your address',
                      ),
                      onChanged: (value) {
                        print('The entered text is: $value');
                      },
                    ),
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      controller: experControl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your experience',
                          fillColor: Colors.white),
                      onChanged: (value) {
                        print('The entered text is: $value');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 76, left: 76),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey),
                    ),
                    child:   MultiSelectDialogField<Skills>(
                      items: Skillsmulti.map((member) => MultiSelectItem<Skills>(
                          member, member.name.toString())).toList(),
                      initialValue: selectedOptionsIdsskills.map((id) {
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
                          selectedOptionsIdsskills =
                              values.map<int>((member) => member.id!).toList();
                          print("Options: $selectedOptionsIdsskills");
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
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        width: 270,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors
                                .blue), // Set the background color of the ElevatedButton
                          ),
                          onPressed: _openFilePicker,
                          child: Text('upload resume'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _filePathname,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 78.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: result?.files.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(result?.files[index].name ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 76, left: 76,bottom: 20),
                  child: Container(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        _validate();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          " Update",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //
          ]),
        ));
  }

  String _filePath = 'No file selected';
  String _filePathname = "";
  void _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          PlatformFile file = result.files.single;
          _filePath = file.path!;
          _filePathname = file.name;
          print('Selected file name: $_filePathname');
        });
      } else {
        setState(() {
          _filePath = 'No file selected';
          _filePathname = '';
        });
      }
    } catch (e) {
      print("File picking failed: $e");
    }
  }


  _validate() async {
    var profesion=profControl.text;
    var address=addressControl.text;
    var  experince=experControl.text;

    if (selectedOptionsIdsinterest.isEmpty) {
      return toastMessage("Please select interests");
    }  else if (selectedOptionsIdsskills.isEmpty) {
      return toastMessage("Please select skills");
    }
    if (_filePath == 'No file selected' || _filePathname.isEmpty) {
      return toastMessage("Please upload resume");
    }
    if (experince ==null) {
      return toastMessage("Please enter your experince");
    }
    if (profesion ==null && formatAndValidate.validateName(profesion) != null) {
      return toastMessage("Please enter your professional");
    }
    if (address ==null && formatAndValidate.validateAddress(address) != null) {
      return toastMessage("Please enter your address");
    }
    return await _updateProfile(_filePath,selectedOptionsIdsinterest,address,experince,profesion,selectedOptionsIdsskills);
  }
  _updateProfile(String image, List<int> interestsids,address, years, profesion,
      List<int> skillsids) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _authBloc.editProfile(
      image,
      interestsids,
      address,
      years,
      profesion,
      skillsids,
    );
  }
}



