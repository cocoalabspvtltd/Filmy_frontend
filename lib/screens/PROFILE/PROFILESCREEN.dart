import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:film/screens/PROFILE/gallery.dart';
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
  List<int> selectedOptionsIds = [];
  List<dynamic> juryList = [];
  AuthBloc _authBloc = AuthBloc();
  @override
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
  TextEditingController skillControl = TextEditingController();
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
  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse('${Apis.url}${User_Details.userRole =="professional"?Apis.professUpdateprofilepic:Apis.userUpdateprofilepic}');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer ${User_Details.apiToken}';
    request.headers['content-type'] = 'application/json';
    request.files.add(http.MultipartFile(
      'profile_picture',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: 'image.jpg', // Provide a filename here
      // Adjust content type if necessary
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(await response.stream.bytesToString());


      image = jsonResponse["picture"]["image"];

      // Return the full image URL

      print('Image uploaded successfully=>${image}');
      // Handle success response
    } else {
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
                GestureDetector(
                  onTap: _pickImage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: _image == null
                            ? ClipOval(
                                child: Image.network(
                                  '$baseUrl/$image',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  '${User_Details.userbaseur}/${User_Details.userimage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Icon(Icons.edit),
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
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: skillControl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your Skill',
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
                    child: MultiSelectDialogField<Skills>(
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
                        chipColor: Colors.white,
                        textStyle: TextStyle(color: Colors.black),
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
                      right: 76, left: 76, top: 10, bottom: 20),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        print("skill=>${skillControl.text}");
                        // Navigate to the CompleteProfile screen using Get.to method
                        await _addPropertyFun(
                            _filePath,
                            skillControl.text,
                            addressControl.text,
                            experControl.text,
                            profControl.text,
                            selectedOptionsIds);
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

  _addPropertyFun(String image, String interests, profesion, address, years,
      List<int> ids) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _authBloc.addProperty(
      image!,
      interests,
      address,
      years,
      profesion,
      ids,
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
