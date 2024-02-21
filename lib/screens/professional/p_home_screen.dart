import 'package:film/models/profile.dart';
import 'package:film/screens/professional/component/professionl_home.dart';
import 'package:film/screens/professional/component/project_list_screen.dart';
import 'package:film/screens/professional/create_project_screen.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/shared_prefs.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/material.dart';


class PHomeScreen extends StatefulWidget {
  const PHomeScreen({Key? key}) : super(key: key);

  @override
  State<PHomeScreen> createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen> {

  late int _selectedIndex;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3;
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        backgroundColor: Colors.cyan,
        title: Text("Hi ${User_Details.userName}"),
        actions: [
          IconButton(onPressed: (){
            SharedPrefs.logOut();
          }, icon: Icon(Icons.logout)),
        ],
        toolbarHeight: 140,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[50],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyan,
        onTap: _onTappedItem,
        currentIndex: _selectedIndex,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            label: "Hiring",
            icon: Icon(Icons.work_outline_outlined)
          ),
          BottomNavigationBarItem(
            label: "Projects",
              icon: Icon(Icons.propane_tank_outlined)
          ),
          BottomNavigationBarItem(
            label: "profile",
              icon: Icon(Icons.person_outline)
          ),
          BottomNavigationBarItem(
            label: "Home",
              icon: Icon(Icons.home_filled)
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        toastMessage("Double press back to exit");
        return Future.value(false);
      }
      return Future.value(true);
    },
    child: _selectedIndex == 3
    ? ProfessionalHome()
        : _selectedIndex == 2
    ? Text("Profile")
        : _selectedIndex == 1
    ? ProjectListScreen()
        : _selectedIndex == 0
    ? Text("Hiring")
        : Center(child: Text("hai")),
    ),

    );

  }

}
