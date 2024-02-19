import 'dart:async';

import 'package:film/screens/authscreens/loginscreen.dart';
import 'package:film/screens/authscreens/splashpage.dart';
import 'package:flutter/material.dart';


import '../../core/colors.dart';
import '../../core/space.dart';
import '../../core/text_style.dart';
import '../../utils/api_helper.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/user.dart';
import '../../widget/main_button.dart';
import 'login.dart';

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

      if (UserDetails.apiToken.isEmpty) await SharedPrefs.init();
      await SharedPrefs.init();

      // Future.delayed(Duration(milliseconds: 1400), () {
      //   if (UserDetails.apiToken.isNotEmpty) {
      //     print("Token-->${UserDetails.apiToken}");
      //     print("role___________" + UserDetails.userRole);
      //     if (UserDetails.userRole == 'admin') {
      //       return Get.offAll(() => AdminHomeScreen());
      //     } else if (UserDetails.userRole == 'college') {
      //        return Get.offAll(() => CollegeHomeScreen());
      //     }
      //     else {
      //        return Get.offAll(() => CommitteHomeScreen());
      //     }
      //   } else {
      //      return Get.offAll(() => LoginScreen());
      //   }
      // });
    });
    Timer(
        Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
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
