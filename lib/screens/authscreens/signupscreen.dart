

import 'dart:async';
import 'dart:convert';

import 'package:film/screens/authscreens/loginscreen.dart';
import 'package:film/widgets/stringvalidator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../bloc/authBloc/auth.dart';
import '../../core/colors.dart';
import '../../core/colors.dart';
import '../../models/common.dart';
import '../../utils/api_helper.dart';
import '../../utils/string_formatter_and_validator.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({Key? key}) : super(key: key);

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}
List<String> gender = ["Select", "male", "female", "Others"];
List<String> role = ["Select", "public-user", "professionals"];
AuthBloc? _authBloc;
String selectedGender = "";
String? toDateInString;
DateTime? toDate;
bool? istoDateSelected;
String dropdownValuegender = "Select";
String dropdownValuerole = "Select";
TextEditingController user = TextEditingController();
TextEditingController pass_word = TextEditingController();
TextEditingController confirpass = TextEditingController();
TextEditingController email_address = TextEditingController();
TextEditingController phno = TextEditingController();
TextEditingController agecon = TextEditingController();
TextEditingController dob = TextEditingController();

class _SignupscreenState extends State<Signupscreen> {
  @override
  void initState() {
    _authBloc = AuthBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(38.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              const Text(
              "Sign up ",
              style: TextStyle(
              fontSize: 26,
              color: Color(0xFF4DD0E1),
    height: 2,
    fontWeight: FontWeight.bold),
    ),
    const SizedBox(
    height: 16,
    ),
    TextField(
    style: const TextStyle(color: Colors.cyan),
    controller: email_address,
    decoration: InputDecoration(
    hintText: 'Enter Email',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    const SizedBox(
    height: 16,
    ),
    TextField(
    style: const TextStyle(color: Colors.cyan),
    controller: user,
    decoration: InputDecoration(
    hintText: 'Enter Username',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    const SizedBox(
    height: 16,
    ),
    TextField(
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.cyan),
    controller: phno,
    decoration: InputDecoration(
    hintText: 'Enter phone Number',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    const SizedBox(
    height: 16,
    ),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Colors.grey.withOpacity(0.1),
    border: Border.all(color: Colors.grey.withOpacity(0.1)),
    ),
    child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
    value: dropdownValuegender,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 32,
    elevation: 16,
    style: TextStyle(
    color: Colors.black,
    fontSize: 18,
    ),
    onChanged: (String? newValue) {
    setState(() {
    dropdownValuegender = newValue!;
    });
    },
    items: gender.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Container(
    width: 200, // Set the width of each dropdown item
    child: Text(
    value,
    style: TextStyle(color: Colors.cyan),
    ),
    ),
    );
    }).toList(),
    ),
    ),
    ),
    const SizedBox(
    height: 16,
    ),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Colors.grey.withOpacity(0.1),
    border: Border.all(color: Colors.grey.withOpacity(0.1)),
    ),
    child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
    value: dropdownValuerole,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 32,
    elevation: 16,
    style: TextStyle(
    color: Colors.black,
    fontSize: 18,
    ),
    onChanged: (String? newValue) {
    setState(() {
    dropdownValuerole = newValue!;
    });
    },
    items: role.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Container(
    width: 200, // Set the width of each dropdown item
    child: Text(
    value,
    style: TextStyle(color: Colors.cyan),
    ),
    ),
    );
    }).toList(),
    ),
    ),
    ),
    SizedBox(
    height: 16,
    ),
    TextField(
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.cyan),
    controller: agecon,
    decoration: InputDecoration(
    hintText: 'Enter age',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    SizedBox(
    height: 16,
    ),
    TextFormField(
    style: TextStyle(color: Colors.cyan),
    onTap: () {
    _calenderDatePick();
    },
    controller: dob,
    keyboardType: TextInputType.datetime,
    decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
    borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    hintText: 'Choose date',
    hintStyle: TextStyle(color: Colors.cyan),
    suffixIcon: _calenderDatePick(),
    ),
    ),
    SizedBox(
    height: 16,
    ),
    TextField(
    style: const TextStyle(color: Colors.cyan),
    obscureText: true,
    controller: pass_word,
    decoration: InputDecoration(
    hintText: 'Password',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    const SizedBox(
    height: 16,
    ),
    TextField(
    style: const TextStyle(color: Colors.cyan),
    obscureText: true,
    controller: confirpass,
    decoration: InputDecoration(
    hintText: 'Confirm Password',
    hintStyle: const TextStyle(
    fontSize: 16,
    color: Colors.cyan,
    fontWeight: FontWeight.bold,
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(
    width: 0,
    style: BorderStyle.none,
    ),
    ),
    filled: true,
    fillColor: Colors.grey.withOpacity(0.1),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    ),
    ),
    const SizedBox(
    height: 24,
    ),
    Container(
    height: 40,
    decoration: BoxDecoration(
    color: Color(0xFF4DD0E1),
    borderRadius: const BorderRadius.all(
    Radius.circular(25),
    ),
    boxShadow: [
    BoxShadow(
    color: const Color(0xFFF3D657).withOpacity(0.2),
    spreadRadius: 3,
    blurRadius: 4,
    offset: const Offset(0, 3),
    ),
    ],
    ),
    child: Center(
    child: GestureDetector(
    onTap: _validate,
    child: const Text(
    "SIGN UP",
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    )),
    ),
    const SizedBox(
    height: 24,
    ),
    ],
    ),
          ),
        ),
      ));
  }

  _calenderDatePick() {
    return GestureDetector(
        child: new Icon(
          Icons.calendar_month_outlined,
          color: Colors.cyan,
        ),
        onTap: () async {
          final DateTime? datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2030));
          if (datePick != null && datePick != toDate) {
            setState(() {
              toDate = datePick;
              istoDateSelected = true;

              // Format the toDate to "dd-mm-yyyy"
              final DateFormat formatter = DateFormat('dd-MM-yyyy');
              toDateInString = formatter.format(toDate!);
              dob.text = toDateInString!;
            });
          }
        });
  }

  FormatAndValidate formatAndValidate = FormatAndValidate();
  _validate() async {
    String gmail = email_address.text.trim();
    String firstName = user.text.trim();
    String phoneno = phno.text.trim();

    String password = pass_word.text;
    String rePassword = confirpass.text;
    String dobs = dob.text.trim();
    String ages = agecon.text.trim();

    if (!gmail.isValidEmail()) {
      _validationFailed('Please provide a valid email address', email_address);
    } else if (firstName.isEmpty) {
      _validationFailed('Please provide your first name', user);
    } else if (!firstName.isAlphabetOnly) {
      _validationFailed('First name should contain only alphabets', user);
    } else if (!phoneno.isValidMobileNumber()) {
      _validationFailed('Please provide a valid phone number', phno);
    } else if (!ages.isNumericOnly) {
      _validationFailed(' Age Must be a Number', agecon);
    } else if (formatAndValidate.validateDob(dobs) != null) {
      _validationFailed('Please provide a valid format', dob);
    } else if (!password.isValidPassword()['isValid']) {
      _validationFailed(password.isValidPassword()['message'], pass_word);
    } else if (!rePassword.isValidPassword()['isValid']) {
      _validationFailed(rePassword.isValidPassword()['message'], confirpass);
    } else if (password != rePassword) {
      _validationFailed('Password mismatch', confirpass);
    }
    return await _signUp(firstName, gmail, phoneno, password, rePassword, ages);
  }
}

Future _signUp(
    String name,
    String email,
    String phone,
    String pass,
    String repass,
    String age,
    ) async {
  print(
      "${name}${email}${phone}${pass}${repass}${age}${dropdownValuegender}${dropdownValuerole}");

  Map<String, dynamic> body = {};
  body["name"] = name;
  body["email"] = email;
  body["phone"] = phone;
  body["dob"] = toDateInString;
  body["age"] = age;
  body["gender"] = "female";
  body["role"] = dropdownValuerole;
  body["password"] = pass;
  body["password_confirmation"] = repass;
  print("sesdr->${body}");
  try {
    CommonResponse response =
    await _authBloc!.userRegistration(json.encode(body));
    if (response.message == "User registered successfully" || response.statusCode == 201 ) {
      toastMessage("Successfully registered please Login!");
      Get.to((LoginScreen()));
    }
    else {
      toastMessage("${response.message}");
      // user.clear();
      // email_address.clear();
      // pass_word.clear();
      // phno.clear();
      // confirpass.clear();
      // agecon.clear();
      // dob.clear();
      // toDateInString = null;
      // dropdownValuegender = "Select";
      // dropdownValuerole = "Select";
    }
  } catch (e, s) {
    Completer().completeError(e, s);
    toastMessage("Email id already taken!");
    // toastMessage('Something went wrong. Please try again');
  }
}

_validationFailed(
    String msg,
    TextEditingController textFieldControl,
    ) {
  toastMessage(msg);
}
