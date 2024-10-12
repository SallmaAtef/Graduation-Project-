import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapmart/screens/signup_screen.dart';
import 'package:snapmart/screens/userMain.dart';
import 'package:snapmart/screens/userhome.dart';
import 'package:snapmart/screens/vendorMain.dart';
import 'dart:convert';

import '../widgets/constant.dart';
import 'enter.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isVendor = false;
  bool _isUser = false;
  // String _email = '';
  // String _password = '';
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  bool errorEmail = false;
  bool errorPassword = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryLightColor,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: kPrimaryColor,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          children: <Widget>[
            SizedBox(height: 24,),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (context) => UserMain());
                    Navigator.pushReplacement(context, route);

                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      // fontFamily: 'Pacifico',
                      fontSize: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: SizedBox(
                height: height * 0.2,
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailCon,
              onChanged: (v){
                if(v.isNotEmpty){
                  setState(() {
                    errorEmail = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
                prefixIcon: Icon(Icons.email),
                fillColor: kPrimaryColor.withAlpha(40),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none
                ),
                errorText: errorEmail?"this field is required":null,
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                // Add more validation if necessary (e.g., regex for email)
                return null;
              },
            ),
            SizedBox(height: height * 0.03),
            TextFormField(
              obscureText: !_passwordVisible,
              controller: passwordCon,
              onChanged: (v){
                if(v.isNotEmpty){
                  setState(() {
                    errorPassword = false;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
                errorText: errorPassword?"this field is required":null,
                hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                fillColor: kPrimaryColor.withAlpha(40),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                // Add more validation if necessary
                return null;
              },
            ),
            // SizedBox(height: height * 0.02),
            // buildRoleSelection(),
            SizedBox(height: height * 0.06),
            buildLoginButton(),
            SizedBox(height: height * 0.02),
            buildSignupText(context),
            SizedBox(height: height * 0.01),
            // buildForgetPasswordText(context),
          ],
        ),
      ),
    );
  }

  Widget buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildRoleCheckBox('Vendor', _isVendor, (value) {
          setState(() {
            _isVendor = value!;
            if (_isVendor) {
              _isUser = false;
            }
          });
        }),
        SizedBox(width: 20),
        buildRoleCheckBox('User', _isUser, (value) {
          setState(() {
            _isUser = value!;
            if (_isUser) {
              _isVendor = false;
            }
          });
        }),
      ],
    );
  }

  Widget buildRoleCheckBox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(
          title,
          style: TextStyle(color: kPrimaryColor, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Builder(
        builder: (context) => TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              kPrimaryColor,
            ),
          ),
          onPressed: () async {
            var email = emailCon.text.trim().toString();
            var password = passwordCon.text.trim().toString();
            final FirebaseAuth auth = FirebaseAuth.instance;

            if(email.isNotEmpty&&password.isNotEmpty){
              try{
                await auth.signInWithEmailAndPassword(email: email, password: password).then((value){

                  FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString()).once().then((value){
                    if(value.snapshot.exists){
                      Map o = value.snapshot.value as Map;
                      var type = o.containsKey("type")?o["type"]:"";

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Signed in"),
                      ));
                      if(type == "user"){
                        Route route = MaterialPageRoute(builder: (context) => UserMain());
                        Navigator.pushReplacement(context, route);

                      }else if(type == "vendor"){
                        Route route = MaterialPageRoute(builder: (context) => VendorMain());
                        Navigator.pushReplacement(context, route);

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("ERROR OCCURRED"),
                        ));
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("ERROR OCCURRED"),
                      ));
                    }
                  });
                });
              }on FirebaseException catch(e){
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("there is no account for this email"),
                  ));
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Wrong Password"),
                  ));
                  print('Wrong password provided for that user.');
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error ${e.code}"),
                  ));
                }
              }
            }else{
              if(email.isEmpty){
                setState(() {
                  errorEmail = true;
                });
              }

              if(password.isEmpty){
                setState(() {
                  errorPassword = true;
                });
              }
            }
            // if (_formKey.currentState!.validate()) {
            //   if (_isVendor) {
            //     bool loginSuccessful = await login(_email, _password);
            //     if (loginSuccessful) {
            //       // Navigator.pushNamed(context, ShopByCategoriesPage.id);
            //     } else {
            //       showErrorSnackbar(context);
            //     }
            //   } else if (_isUser) {
            //     bool loginSuccessful = await login(_email, _password);
            //     if (loginSuccessful) {
            //       Navigator.pushNamed(context, UserHome.id);
            //     } else {
            //       showErrorSnackbar(context);
            //     }
            //   } else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text('Please select an option'),
            //       ),
            //     );
            //   }
            // }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Login',
              style: TextStyle(color: kPrimaryLightColor, fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> login(String email, String password) async {
    final apiUrl = 'http://127.0.0.1:8000/token';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Handle successful login (e.g., save token, navigate)
      return true;
    } else {
      return false;
    }
  }

  void showErrorSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid email or password'),
      ),
    );
  }

  Widget buildSignupText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Don\'t have an account?',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignupScreen.id);
          },
          child: const Text(
            '  Signup',
            style: TextStyle(fontSize: 16, color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  showLoaderDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: false,

        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.all(12),
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 48,vertical: 24),
                child: Column(
                  children: [
                    // SizedBox(width: 24,),
                    Spacer(),
                    Text("Signing In...",
                      style: TextStyle(fontSize: 18, color: Colors.indigo,fontWeight: FontWeight.bold
                      ),)
                    , SizedBox(height: 24,),
                    SizedBox(
                      width: 140,
                      height: 4,
                      child: LinearProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                    Spacer(),
                  ],),
              ),
            ),
          );
        });
  }


// Widget buildForgetPasswordText(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       const Text(
  //         'Forget Password?',
  //         style: TextStyle(color: kPrimaryColor, fontSize: 16),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           //   Navigator.pushNamed(context, ForgetScreen.id);
  //         },
  //         child: const Text(
  //           'Reset',
  //           style: TextStyle(fontSize: 16, color: Colors.grey),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
