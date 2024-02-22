
import 'package:film/screens/professional/hiring/create_hiring_screen.dart';
import 'package:film/screens/professional/projects/create_project_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfessionalHome extends StatefulWidget {
  const ProfessionalHome({Key? key}) : super(key: key);

  @override
  State<ProfessionalHome> createState() => _ProfessionalHomeState();
}

class _ProfessionalHomeState extends State<ProfessionalHome> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(12.0),
          child: Column(
            children: [
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
                      Get.to(() => CreateHiringScreen(ProjectId: '',));
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
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: AssetImage(
                              'assets/image/no-post.png'),
                          height: 200,
                          width: 150,
                        ),
                        Text(
                            "Currently No Post Available"),

                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );

  }

}
