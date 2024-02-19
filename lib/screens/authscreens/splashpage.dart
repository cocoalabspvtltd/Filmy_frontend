
import 'package:film/screens/authscreens/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'signupoptions.dart';
import 'login.dart';
import 'loginoptions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool login = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            GestureDetector(
              onTap: () {
                setState(() {
                  login = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                height: login ? MediaQuery.of(context).size.height * 0.6 : MediaQuery.of(context).size.height * 0.4,
                child: CustomPaint(
                  painter: CurvePainter(login),
                  child: Container(
                    padding: EdgeInsets.only(bottom: login ? 0 : 55),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: login
                              ? const Login()
                              : const LoginOption(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  login = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                height: login ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height * 0.6,
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(top: login ? 55 : 0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: !login
                              ? SignUp()
                              : const SignUpOption(),
                        ),
                      ),
                    )
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {

  bool outterCurve;

  CurvePainter(this.outterCurve);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.shader =  RadialGradient(
      colors: [
        Color(0xFF4DD0E1),
        Color(0xFF4DD0E1),
      ],
    ).createShader(Rect.fromCircle(
      radius: 600, center: const Offset(50, 50),
    ));
    paint.style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, outterCurve ? size.height + 110 : size.height - 110, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'),),

      body:  const Center(child: Text('Dashboard')),
    );
  }
}