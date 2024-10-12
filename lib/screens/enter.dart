import 'package:flutter/material.dart';
import 'package:snapmart/screens/signup_screen.dart';
import 'package:snapmart/screens/userMain.dart';
import 'package:snapmart/screens/userhome.dart';
import 'package:snapmart/screens/vendorMain.dart';
import 'package:snapmart/screens/vendor_details.dart';
import 'package:snapmart/widgets/constant.dart';

import 'login_screen.dart';

class FirstScreen extends StatelessWidget {
  static String id = 'FirstScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'SNAPMART',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 35,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 110),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 109),
                decoration: BoxDecoration(
                  color: kPrimaryColor, // Set the background color here
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 16,
                    color: Colors.white, // Set the text color
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SignupScreen.id);
              },
              child: Container(
                // padding: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                decoration: BoxDecoration(
                  color: kPrimaryColor, // Set the background color here
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'SIGNUP',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 16,
                    color: Colors.white, // Set the text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain(),));
                    // Navigator.pushNamed(context, UserHome.id);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        VendorMain(),));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'VENDOR',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
