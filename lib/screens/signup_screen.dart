import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapmart/screens/userMain.dart';
import 'dart:convert';

import 'package:snapmart/screens/userhome.dart';

import '../models/uploadUser.dart';
import '../widgets/constant.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController addressCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController confirmPasswordCon =
      TextEditingController();
  bool _isLoading = false;

  bool errorName = false;
  bool errorAddress = false;
  bool errorEmail = false;
  bool errorPassword = false;
  bool errorConfirm = false;
  String errorEmailText = "";
  String errorPasswordText = "";
  @override
  void dispose() {
    emailCon.dispose();
    passwordCon.dispose();
    nameCon.dispose();
    confirmPasswordCon.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,

        backgroundColor: kPrimaryLightColor,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   color: kPrimaryColor,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Top part: 'Sign up' text

                // Middle part: Form with centered SizedBox widgets
                Expanded(
                  child: Form(
                    key: _globalKey,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 60,
                              bottom: 20), // Adjust the padding to position the text
                          child: Text(
                            'Sign up',textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontSize: 40,
                                color: kPrimaryColor),
                          ),
                        ),
                        SizedBox(
                            height: height * .07),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: nameCon,
                            onChanged: (v){
                              if(v.isNotEmpty){
                                setState(() {
                                  errorName = false;
                                });
                              }
                            },
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              hintText: 'Enter your Name',
                              errorText: errorName?"this field is required":null,
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 168, 168, 168)),
                              prefixIcon: const Icon(Icons.person),
                              fillColor: kPrimaryColor.withAlpha(40),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: height * .02),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: addressCon,
                            onChanged: (v){
                              if(v.isNotEmpty){
                                setState(() {
                                  errorAddress = false;
                                });
                              }
                            },
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              hintText: 'Enter your Address',
                              errorText: errorAddress?"this field is required":null,
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 168, 168, 168)),
                              prefixIcon: const Icon(Icons.home_outlined),
                              fillColor: kPrimaryColor.withAlpha(40),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: height * .02),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: emailCon,
                            onChanged: (v){
                              if(v.isNotEmpty){
                                setState(() {
                                  errorEmail = false;
                                });
                              }
                            },
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              errorText: errorEmail?errorEmailText:null,
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 168, 168, 168)),
                              prefixIcon: const Icon(Icons.email),
                              fillColor: kPrimaryColor.withAlpha(40),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: height * .02), // SizedBox in the middle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller: passwordCon,
                            onChanged: (v){
                              if(v.isNotEmpty){
                                setState(() {
                                  errorPassword = false;
                                });
                              }
                            },
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              fillColor: kPrimaryColor.withAlpha(40),
                              filled: true,
                              errorText: errorPassword?errorPasswordText:null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              ),
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 168, 168, 168)),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: height * .02), // SizedBox in the middle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            obscureText: !_confirmPasswordVisible,
                            controller: confirmPasswordCon,
                            cursorColor: kPrimaryColor,
                            onChanged: (v){
                              if(v.isNotEmpty){
                                setState(() {
                                  errorConfirm = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: kPrimaryColor.withAlpha(40),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              ),
                              hintText: 'Confirm password',
                              errorText: errorConfirm?"the password must match":null,
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 168, 168, 168)),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordCon.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: height * .05), // SizedBox in the middle

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: InkWell(
                            onTap: () async {

                              final FirebaseAuth auth = FirebaseAuth.instance;
                              var name = nameCon.text.trim().toString();
                              var email = emailCon.text.trim().toString();
                              var address = addressCon.text.trim().toString();
                              var password = passwordCon.text.trim().toString();
                              if(name.isNotEmpty&&address.isNotEmpty&&
                                  email.length>60&&
                                  email.length<15&&password.length<6)
                              {
                                showLoaderDialog(context);
                                try {
                                  await auth
                                      .createUserWithEmailAndPassword(
                                      email: email, password: password)
                                      .then((result) {
                                    var upload = UploadUser( name, "", "", address, "user");
                                    FirebaseDatabase.instance.ref("users").child(FirebaseAuth.instance.currentUser!.uid.toString()).
                                    set(upload.toJson()).then((value) {
                                      Navigator.pop(context);
                                      Route route = MaterialPageRoute(builder: (context) => UserMain());
                                      Navigator.pushReplacement(context, route);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.indigo,
                                            content: Text("A new Account created for $email",style: TextStyle(
                                                color: Colors.white,fontSize: 16
                                            ),),
                                          ));
                                    });
                                  });

                                }on FirebaseAuthException catch (e){
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("Error ${e.message}"),
                                  ));
                                }
                              }else{
                                if(name.isEmpty){
                                  setState(() {
                                    errorName = true;
                                  });
                                }
                                if(address.isEmpty){
                                  setState(() {
                                    errorAddress = true;
                                  });
                                }
                                if(confirmPasswordCon.text.trim().isEmpty){
                                  setState(() {
                                    errorConfirm = true;
                                  });
                                }
                                if(password.length>20||password.length<6){
                                  setState(() {
                                    errorPassword = true;
                                    errorPasswordText = "the password should be between 6 and 20 characters";
                                  });
                                }
                                if(password.isEmpty){
                                  setState(() {
                                    errorPassword = true;
                                    errorPasswordText = "this field is required";
                                  });
                                }

                                 if(email.length>60||email.length<15) {
                                   setState(() {
                                     errorEmail = true;
                                     errorEmailText =
                                     "the email should be between 20 and 60 characters";
                                   });
                                 }
                                  if(email.isEmpty){
                                  setState(() {
                                    errorEmail = true;
                                    errorEmailText = "this field is required";
                                  });
                                }


                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Error All fields are required"),
                                ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: const Text(

                                  'Sign up',textAlign: TextAlign.center,
                                  style: TextStyle(color: kPrimaryLightColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: height * .03), // SizedBox in the middle


                        Padding(
                          padding: EdgeInsets.only(
                              bottom: height * 0.01), // Adjust padding as needed
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.popAndPushNamed(context, LoginScreen.id);
                                },
                                child: const Text(
                                  ' Login',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 60),
                        //
                        //   child: SizedBox(
                        //     width: double
                        //         .infinity, // This will make the button fill the available space
                        //     child: OutlinedButton(
                        //       style: OutlinedButton.styleFrom(
                        //         backgroundColor: kPrimaryColor,
                        //         side: const BorderSide(color: kPrimaryColor),
                        //       ),
                        //       onPressed: (){
                        //
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: const Text(
                        //           'Sign up',
                        //           style: TextStyle(color: kPrimaryLightColor),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Bottom part: 'Already have an account? Login'

              ],
            ),
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
                    Text("Creating New Account",
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

}
