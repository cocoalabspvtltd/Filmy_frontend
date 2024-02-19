

import 'dart:convert';

import 'package:film/screens/PROFILE/PROFILESCREEN.dart';
import 'package:film/screens/authscreens/signup.dart';
import 'package:film/screens/authscreens/signupscreen.dart';
import 'package:film/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../bloc/authBloc/auth.dart';
import '../../models/login_response.dart';
import '../../utils/api_helper.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/string_formatter_and_validator.dart';
import '../homescreens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc _authBloc = AuthBloc();

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  FormatAndValidate formatAndValidate = FormatAndValidate();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.cyan,

      body: SafeArea(child:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              "Welcome to",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1C),
                height: 2,
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              "Filmy",
              style: TextStyle(
                fontSize: 37,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
                height: 1,
              ),
            ),



            const SizedBox(
              height: 16,
            ),


            TextField(
              controller: user,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email / Username',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              controller: pass,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C1C1C).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                  child: GestureDetector(
                    onTap: (){
                      _validate();
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                const Text(
                  "FORGOT PASSWORD?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1C1C),
                    height: 1,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: (){  Get.to(() => Signupscreen());},
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1C),
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      )
      ));
  }

          _validate() async {
    var email = user.text;
    var password =pass.text;

    if (formatAndValidate.validateEmailID(email) != null) {
      return toastMessage(formatAndValidate.validateEmailID(email));
    } else
    if (password == "" || password.length < 6) {
    return toastMessage("Password length must be more than 6");
    }
    return await _login(email, password);
    }

        Future _login(String email, String password) async {
    AppDialogs.loading();
      Map<String, dynamic> body = {};
      body["email"] = email;
      body["password"] = password;
      try {
        LoginResponse response = await _authBloc.login(json.encode(body));
        print("response.success-->${response.success}");
        if (response.success == true) {
          toastMessage("Login Successfully" ?? '');
          await SharedPrefs.logIn(response);
          Get.to(() => ProfilePage());

          // if (response.user!.role == "admin") {
          //   Get.offAll(() => AdminHomeScreen());
          // } else if (response.user!.role == "college") {
          //   Get.offAll(() => CollegeHomeScreen());
          // } else {
          //   Get.offAll(() => CommitteHomeScreen());
          // }
        }  else {

          toastMessage("response.message" ?? '');
        }
      } catch (error) {

        // toastMessage('Please enter valid email and password');
      }
    }


  }

