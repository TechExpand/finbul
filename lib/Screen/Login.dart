import 'package:finbul/Screen/SignUp.dart';
import 'package:finbul/Screen/Recover.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SignIn extends StatelessWidget {
  final form_key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Color(0xFF372C6A),
      body: Form(
        key: form_key,
        child: Stack(
          children: [
            Container(
              color: Color(0xFF372C6A),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Text(''),
            ),
            LayoutBuilder(
              builder: (_, constraints) => Image(
                image: AssetImage('assets/yellow.png'),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.57,
                width: constraints.maxWidth,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 170),
                    child: Image.asset(
                      'assets/Logo_White.png',
                      width: 250,
                    ),
                  ),
                  Spacer(),
                  Container(
                    //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                    width: 240,
                    child: TextFormField(
                        controller: email,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email Required';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white30),
                          labelStyle: TextStyle(color: Colors.white30),
                          labelText: 'Email',
                          hintText: 'finbul@company.com',
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                        )),
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                    width: 240,
                    child: TextFormField(
                        controller: password,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password Required';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white30),
                          labelStyle: TextStyle(color: Colors.white30),
                          labelText: 'Password',
                          hintText: 'Password',
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                        )),
                  ),
                  Align(
                    alignment:Alignment.topRight,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return RecoverPass();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ));
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 34),
                    child: Container(
                      child: FlatButton(
                        onPressed: () {
                          if (form_key.currentState.validate()) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    elevation: 0,
                                    child: CupertinoActivityIndicator(),
                                    backgroundColor: Colors.transparent,
                                  );
                                });

                            FirebaseApi.Login(email.text, password.text,
                                context, scaffoldkey);
                          }
                        },
                        color: Color(0xFFFEB904),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 150.0, minHeight: 53.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Sign in",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          height:1,
                          color:Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:4.0, right:4, ),
                          child: Text('or', style: TextStyle(color: Colors.white),),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/4,
                          height:1,
                          color:Colors.white,
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return SignUpScreen();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ));
                    },
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
