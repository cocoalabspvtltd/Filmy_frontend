import 'package:flutter/material.dart';

class PHomeScreen extends StatefulWidget {
  const PHomeScreen({Key? key}) : super(key: key);

  @override
  State<PHomeScreen> createState() => _PHomeScreenState();
}

class _PHomeScreenState extends State<PHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: 15.0, left: 10, right: 10, bottom: 4),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         "Friend's you might know",
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold, fontSize: 16),
            //       ),
            //       const SizedBox(
            //         height: 8,
            //       ),
            //       // _youKnowWidget(context),
            //     ],
            //   ),
            // )
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  // Add functionality to create project
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        size: 36.0,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Create Project',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
