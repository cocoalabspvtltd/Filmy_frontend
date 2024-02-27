import 'package:film/screens/PROFILE/gallery.dart';
import 'package:film/screens/professional/component/professionl_home.dart';
import 'package:film/screens/professional/component/project_list_screen.dart';
import 'package:film/screens/professional/component/hiring_list_screen.dart';
import 'package:film/screens/user/hiringapplyrequ.dart';
import 'package:film/utils/api_helper.dart';
import 'package:film/utils/shared_prefs.dart';
import 'package:film/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../bloc/authBloc/auth.dart';
import '../PROFILE/PROFILESCREEN.dart';
import '../user/applications_list.dart';

class PHomeScreen extends StatefulWidget {
  final int selectedIndex;
  const PHomeScreen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<PHomeScreen> createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen> {
  late int _selectedIndex;
  DateTime? currentBackPressTime;

  List<String> appBarTitle = [
    User_Details.userRole == "professional" ?  "Hirings":"Applications",
    User_Details.userRole == "professional" ? "Projects" : "Gallery",
    "Profile",
   "Home"
  ];  dynamic ? prepaidCardUserOrNot;
  String ?Message ="";
  String? statuscheck ;
  AuthBloc _userprofilecheckBloc = AuthBloc();

  getProfileUserOrNot() async {
    prepaidCardUserOrNot = await _userprofilecheckBloc.userprofilecheck();
    Message = prepaidCardUserOrNot["status"];
    print("mes-?${Message}");
    statuscheck= prepaidCardUserOrNot["success"];
    if ( Message == "active") {
Get.back();
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Inactive'),
            content: Text('Your profile is inactive. Please contact support for assistance.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
    setState(() {});
  }
  @override
  void initState() {
    getProfileUserOrNot();

    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the background color of the AppBar
        title: Text(
          appBarTitle[_selectedIndex],
          style:
              TextStyle(color: Colors.black), // Set the text color of the title
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,
                color: Colors.cyan), // Set the color of the menu icon
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the side drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.cyan,
            ),
            onPressed: () {
              SharedPrefs.logOut();

              // Handle notification button press
            },
          ),
        ],
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
          User_Details.userRole == "professional"?  const BottomNavigationBarItem(
              label: "Hiring", icon: Icon(Icons.work_outline_outlined)):BottomNavigationBarItem(
              label: "Application", icon: Icon(Icons.work_outline_outlined)),
          User_Details.userRole == "professional"
              ? const BottomNavigationBarItem(
                  label: "Projects", icon: Icon(Icons.propane_tank_outlined))
              : const BottomNavigationBarItem(
                  label: "Gallery", icon: Icon(Icons.propane_tank_outlined)),
          const BottomNavigationBarItem(
              label: "profile", icon: Icon(Icons.person_outline)),
          const BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_filled)),
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
                ? ProfilePage()
                : _selectedIndex == 1
                    ? User_Details.userRole == "professional"
                        ? ProjectListScreen()
                        : Gallery()
                    : _selectedIndex == 0
                        ?User_Details.userRole == "professional"
            ? HiringListScreen()
                        : ApplicationListuser():Center(child: Text("Hai"),)
      ),
    );
  }
}
