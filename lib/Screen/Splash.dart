import 'package:finbul/Screen/HomePage.dart';
import 'package:finbul/Screen/SignUp.dart';
import 'package:finbul/Screen/intro.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import 'Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}



class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  //  Provider.of<WebServices>(context, listen: false).initializeValues();
    Future.delayed(Duration(seconds: 2), go_to_home);
  }

  var uid = '';

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if(info.updateAvailability == UpdateAvailability.updateAvailable){
        InAppUpdate.performImmediateUpdate()
            .catchError((e){
          print(e);
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  go_to_home() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    setState(() {
      uid = user==null?'':user.uid;
    });

    if(uid == null || uid == 'null' || uid.isEmpty) {
      return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return IntroScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child){
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }else{
      DataProvider provide  = Provider.of<DataProvider>(context,  listen: false);
      provide.setUserID(uid);
      return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF372C6A),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF372C6A),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Text(''),
          ),
          LayoutBuilder(
            builder:(_,constraints )=> Image(
              image: AssetImage('assets/yellow.png'),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height*0.57,
              width: constraints.maxWidth,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:200.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Image.asset('assets/Logo_White.png', width: 250,),
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

