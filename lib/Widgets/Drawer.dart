import 'dart:io';

import 'package:finbul/Screen/Login.dart';
import 'package:finbul/Screen/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class Draw extends StatelessWidget {
  const Draw({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Container(
          color: Color(0xFF372C6A),
          child: Column(
            children: [
              DrawerHeader(
                  child: Center(
                    child:  Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Image.asset('assets/LogoYellow.png', width: 200,),
                    ),
                  )),

              ListTile(
                onTap: (){
                  Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                        return Profiles();
                      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                },
                leading: Icon(FeatherIcons.user, color: Colors.white,),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 16,),
                ),
              ),
              Divider(color: Color(0xFF332963), thickness: 2,),

              ListTile(
                onTap: (){
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SignIn();
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child){
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                leading: Icon(Icons.logout, color: Colors.white,),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 16,),
                ),
              ),
              Divider(color: Color(0xFF332963),thickness: 2,),
              ListTile(
                onTap: (){
                  exit(0);
                },
                leading: Icon(Icons.exit_to_app, color: Colors.white,),
                title: Text(
                  'Exit',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 16,),
                ),
              ),

              Divider(color: Color(0xFF332963),thickness: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
