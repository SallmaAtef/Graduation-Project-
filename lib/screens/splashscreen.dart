import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snapmart/screens/login_screen.dart';
import 'package:snapmart/screens/userMain.dart';
import 'package:snapmart/screens/vendorMain.dart';

import '../widgets/constant.dart';
import 'on_boarding.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future(() =>
        Timer(const Duration(seconds: 1), () {
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseDatabase.instance.ref("users").child(
                FirebaseAuth.instance.currentUser!.uid.toString()).once().then((
                value) {
              if (value.snapshot.exists) {
                Map o = value.snapshot.value as Map;
                var type = o.containsKey("type") ? o["type"] : "";
                if (type == "user") {
                  Route route = MaterialPageRoute(
                      builder: (context) => UserMain());
                  Navigator.pushReplacement(context, route);
                } else if (type == "vendor") {
                  Route route = MaterialPageRoute(
                      builder: (context) => VendorMain());
                  Navigator.pushReplacement(context, route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("ERROR OCCURRED"),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("ERROR OCCURRED"),
                ));
              }
            });
          } else {
            Route route = MaterialPageRoute(
                builder: (context) => LoginScreen());
            Navigator.pushReplacement(context, route);
          }
          // Route route = MaterialPageRoute(
          //           builder: (context) => SignInScreen());
          //       Navigator.pushReplacement(context, route);
        }
        )
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white, // Set background color to red
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/icons/online-shopping.png'),
                  width: 350, // Adjust the width as per your requirement
                  height: 350, // Adjust the height as per your requirement
                ),
                SizedBox(height: 5),
                Text(
                  'SNAPMART',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 30,
                    color: kPrimaryColor,
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
