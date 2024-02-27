
import 'package:film/screens/PROFILE/PROFILESCREEN.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  Widget build(BuildContext context) {
    print("jsd-=>${User_Details.userName}");
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none, fit: StackFit.loose,
        children: <Widget>[
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*4/7,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ Color(0xFF4DD0E1),
                    Color(0xFF4DD0E1),],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text
                  (
                    "Hi ${User_Details.userName}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                    )
                ),

                const SizedBox(height: 16,),
                const Text(
                    "Explore  opportunities in the\n world of film.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ProfilePage()));
                  },
                  child: const Text(
                      "PROFLE",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ClippingClass extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var controlPoint = Offset(size.width - (size.width / 2), size.height - 120);
    var endPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}