import 'package:film/screens/authscreens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignalNotifications.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp( MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Filmy",
      routes: {
        '/': (BuildContext context) =>  Splash(),
        // '/home': (BuildContext context) => HomeView(),
      },
      // initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
    );
  }
}
