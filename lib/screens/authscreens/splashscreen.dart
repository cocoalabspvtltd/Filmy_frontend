import 'dart:async';

import 'package:film/screens/PROFILE/PROFILESCREEN.dart';
import 'package:film/screens/authscreens/loginscreen.dart';
import 'package:film/screens/professional/p_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors.dart';
import '../../core/space.dart';
import '../../core/text_style.dart';
import '../../utils/api_helper.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/user.dart';
import '../../widget/main_button.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}
const String splashText = """
 Explore  opportunities in the world of film.

 """;
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setScreenDimensions(context);

      setState(() {});

      if (User_Details.apiToken.isEmpty) await SharedPrefs.init();
      await SharedPrefs.init();

      Future.delayed(Duration(milliseconds: 1400), () {
        if (User_Details.apiToken.isNotEmpty) {
          print("Token-->${User_Details.apiToken}");
          print("role___________" + User_Details.status);
          if (User_Details.userRole == 'public-user'&&User_Details.status=="inactive") {
            return Get.offAll(() => ProfilePage());
          }
          else {
             return Get.offAll(() => PHomeScreen());
          }
        } else {
           return Get.offAll(() => LoginScreen());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: height,
            color: blackBG,
            child: Image.asset(
              'assets/image/movie1.jpg',
              height: height,
              fit: BoxFit.fitHeight,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Filmy',
                        style: headline,
                      ),
                      TextSpan(
                        text: '.',
                        style: headlineDot,
                      ),
                    ]),
                  ),
                  SpaceVH(height: 20.0),
                  Text(
                    splashText,
                    textAlign: TextAlign.center,
                    style: headline2,
                  ),
                  Mainbutton(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) =>  LoginScreen()));
                    },
                    btnColor: blueButton,
                    text: 'Get Started',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
