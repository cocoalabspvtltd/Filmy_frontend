import 'package:film/models/profile.dart';
import 'package:film/screens/professional/create_project_screen.dart';
import 'package:film/utils/shared_prefs.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PHomeScreen extends StatefulWidget {
  const PHomeScreen({Key? key}) : super(key: key);

  @override
  State<PHomeScreen> createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        backgroundColor: Colors.cyan,
        title: Text("Hi ${User_Details.userName}"),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.person_outline,size: 26,)),
          IconButton(onPressed: (){
            SharedPrefs.logOut();
          }, icon: Icon(Icons.logout)),
        ],
        toolbarHeight: 150,
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  onTap: () {
                     Get.to(CreateProjectScreen());
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create Project',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),SizedBox(height: 16.0),
                        Icon(
                          Icons.add,
                          size: 36.0,
                          color: Colors.cyan,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}
