import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:film/screens/PROFILE/gallery.dart';
import 'package:film/screens/PROFILE/update_profile_screen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> inntrest = [
    "Select Intrest",
    "Dubbing",
    "Cinematography",
    "vfx",
    "production",
    "scripting"
  ];
  String dropdownValueinterest = "Select";
  List<Skills> Skillsmulti = [];
  Map<String, String> headers = {
    'Authorization': 'Bearer ${User_Details.apiToken}',
    'Accept': 'application/json', // Assuming JSON content type
  };
  String title = "";
  List<int> selectedOptionsIdsskills = [];
  List<int> selectedOptionsIdsinterest = [];
  List<dynamic> juryList = [];
  AuthBloc _authBloc = AuthBloc();
  @override
  dynamic ? prepaidCardUserOrNot;
  String ?Message ="";
  String? statuscheck ;
  AuthBloc _userprofilecheckBloc = AuthBloc();

  getProfileUserOrNot() async {
    prepaidCardUserOrNot = await _userprofilecheckBloc.userprofilecheck();
    Message = prepaidCardUserOrNot["status"];
    print("mes-?${Message}");
    statuscheck= prepaidCardUserOrNot["success"];
    if ( Message == "active") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile active'),
            content: Text('Your profile is active.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
              Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );


    } else {
      Get.back();
    }
    setState(() {});
  }
  void initState() {
    super.initState();
    getProfileUserOrNot();
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
      juryList = jsonResponse['skills'];
      print("jury->${juryList}");

      setState(() {
        Skillsmulti = juryList.map((e) => Skills.fromJson(e)).toList();
      });
    } else {
      // If API call fails, handle the error
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

  File? _image;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        _image = imageFile;
      });

      await _uploadImage(imageFile); // Upload the image
    }
  }
  String baseUrl = "";
  String image = "";
  bool isLoading = false;

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse('${Apis.url}${Apis.professUpdateprofilepic}');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${User_Details.apiToken}';
    request.headers['content-type'] = 'application/json';
    request.files.add(http.MultipartFile(
      'profile_picture',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: 'image.jpg', // Provide a filename here
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
      json.decode(await response.stream.bytesToString());

      setState(() {
        image = jsonResponse["picture"]["image"];
        baseUrl = jsonResponse["baseUrl"];
        isLoading = false;
      });

      // Handle success response
      print("Response: $jsonResponse");
      print('Image uploaded successfully: $image');
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to upload image');
      // Handle error response
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.cyan,
        //   title: Row(
        //     children: [
        //       Text("Profile"),
        //       Spacer(),
        //       GestureDetector(
        //           onTap: () {
        //             Get.to(Gallery());
        //           },
        //           child: Text("gallery"))
        //     ],
        //   ),
        // ),
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
                Container(
                  height: 130,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 120,
                          height: 120,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _image != null
                                ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                              '${baseUrl}/${image}',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => GestureDetector(
                                onTap: () async {
                                  await _pickImage();
                                },
                                child: CircleAvatar(
                                  radius: 46.0,
                                  backgroundImage:
                                  AssetImage('assets/images/person.png'),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            )
                                : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                              '${User_Details.userbaseur}/${User_Details.userimage}',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => GestureDetector(
                                onTap: () async {
                                  await _pickImage();
                                },
                                child: CircleAvatar(
                                  radius: 46.0,
                                  backgroundImage:
                                  AssetImage('assets/images/dp.png'),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width / 3,
                        bottom: 10,
                        child: InkWell(
                          onTap: () async {
                            await _pickImage();
                          },
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
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
                SizedBox(
                  height: 16,
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

                const SizedBox(
                  height: 10,
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
                //
                Padding(
                  padding: const EdgeInsets.only(
                      right: 76, left: 76, top: 5, bottom: 20),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigate to the CompleteProfile screen using Get.to method
                        _validate();
                        // await _addPropertyFun(
                        //     _filePath,
                        //     selectedOptionsIdsinterest,
                        //     addressControl.text,
                        //     experControl.text,
                        //     profControl.text,
                        //     selectedOptionsIdsskills);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          " Complete Your Profile",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 76, left: 76, bottom: 20),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.to(UpdateProfileScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Edit Your Profile",
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
          // Get the selected file
          PlatformFile file = result.files.single;
          // Get the file's path
          _filePath = file.path!;
          // Get the file's name
          _filePathname = file.name;
          // Do something with the file's name
          print('Selected file name: $_filePathname');
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
   } else if (formatAndValidate.validateName(profesion) != null) {
      return toastMessage("Please enter your professional");
    } else if (formatAndValidate.validateAddress(address) != null) {
      return toastMessage("Please enter your address");
    } else if (selectedOptionsIdsskills.isEmpty) {
      return toastMessage("Please select skills");
    }else if (_filePath.isEmpty) {
      return toastMessage("Please upload resume");
    }
    return await _addPropertyFun(_filePath,selectedOptionsIdsinterest,address,experince,profesion,selectedOptionsIdsskills);
  }
  _addPropertyFun(String image, List<int> interestsids,address, years, profesion,
      List<int> skillsids) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _authBloc.addProperty(
      image!,
      interestsids,
      address,
      years,
      profesion,
      skillsids,
    );

  }
}

List<File> _selectedFiles = [];

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF4DD0E1);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
