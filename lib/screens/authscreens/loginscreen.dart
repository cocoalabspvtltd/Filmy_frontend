import 'dart:convert';
import 'package:film/screens/PROFILE/PROFILESCREEN.dart';
import 'package:film/screens/authscreens/signupscreen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:film/utils/user.dart';
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
import 'forgotpassword.dart';
import 'package:http/http.dart' as http;

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
  bool _obscureTextPassword = true;

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
              obscureText: _obscureTextPassword,
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
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureTextPassword = !_obscureTextPassword;
                    });
                  },
                  child: Icon(
                    _obscureTextPassword
                        ? Icons.visibility_off :Icons.visibility,
                    color: Colors.white,
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
                GestureDetector(
                  onTap: (){Get.to(()=>ForgotPasswordScreen());},
                  child: const Text(
                    "FORGOT PASSWORD?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1C),
                      height: 1,
                    ),
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

    // Prepare the request body
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };


    try {
      final response = await http.post(
        Uri.parse('https://cocoalabs.in/Filmy/public/api/login'),
        body: body,
      );
      Get.back();
      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        if (loginResponse.success == true) {
          toastMessage("Login Successfully");
          print("sttsus->${loginResponse.user!.status}");
          await SharedPrefs.logIn(loginResponse);
          if (loginResponse.user!.role == "public-user" || loginResponse.user!.status == "inactive") {
            Get.offAll(() => PHomeScreen(selectedIndex:2));
          } else {
            Get.offAll(() => PHomeScreen(selectedIndex: 3,));
          }
        }else {
          if (response.statusCode == 200) {
            toastMessage('You are not authorized!');
          } else {
            toastMessage(loginResponse.message ?? '');
          }
        }
      } else if (response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('errors')) {
          final errors = jsonResponse['errors'];
          if (errors.containsKey('email')) {
            toastMessage(errors['email'][0]);
          }
        } else {
          toastMessage('Validation errors: ${jsonResponse['message']}');
        }
      } else {
        toastMessage('${json.decode(response.body)['message']}');
      }
    } catch (error) {
      Get.back();
      toastMessage('Failed to login. Please check your internet connection.');
    }
  }

  }

