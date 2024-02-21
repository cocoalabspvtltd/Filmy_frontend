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
              if(User_Details.userRole=="professionals")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CreateProjectScreen());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(13.0),
                              bottomRight: const Radius.circular(13.0))),
                      child: Column(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.width * 0.36) / 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: new BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                    bottomRight: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                  ),
                                ),
                                child:
                              Icon(Icons.propane_tank_outlined),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Projects",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(13.0),
                              bottomRight: const Radius.circular(13.0))),
                      child: Column(
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.width * 0.36) / 2,
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: new BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                    bottomRight: Radius.circular(
                                        (MediaQuery.of(context).size.width * 0.36).toDouble()),
                                  ),
                                ),
                                child: Icon(Icons.add_card_outlined)),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Hiring",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

}
