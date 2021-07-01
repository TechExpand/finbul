import 'package:fin_bul/Screen/Login.dart';
import 'package:fin_bul/Service/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {

  final form_key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  final  scaffoldkey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldkey,
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
            child: Form(
    key:form_key,
    child:Column(
              children: [
                Spacer(),
                 Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Image.asset('assets/Logo_White.png', width: 250,),
                  ),

                Spacer(),
                Container(
                  //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                  width: 240,
                  child: TextFormField(
                      controller: username,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Username Required';
                        }
                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white30),
                        labelStyle: TextStyle(color: Colors.white30),
                        labelText: 'Username',
                        hintText: '@finbu',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      )),
                ),
                Container(
                  //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                  width: 240,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                      controller: number,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Phone Required';
                        }
                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white30),
                        labelStyle: TextStyle(color: Colors.white30),
                        labelText: 'Phone',
                        hintText: '0987633244',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      )),
                ),
                Container(
                  //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                  width: 240,
                  child: TextFormField(
                      controller: name,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name Required';
                        }
                        return null;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white30),
                        labelStyle: TextStyle(color: Colors.white30),
                        labelText: 'Name',
                        hintText: 'finbul',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      )),
                ),
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
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
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
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      )),
                ),
                 TextButton(
                    onPressed: (){
                      Navigator.push(context,  PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation){
                        return SignIn();
                      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                    },
                    child: Text('Already have an account?', style: TextStyle(color: Colors.white),),
                  ),

                Padding(
                  padding: EdgeInsets.only( top: 34),
                  child: Container(
                    child: FlatButton(
                      onPressed: () {
                        if(form_key.currentState.validate()){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  elevation: 0,
                                 child:  CupertinoActivityIndicator(),
                                  backgroundColor: Colors.transparent,
                                );
                              });


                          FirebaseApi.register(email.text, password.text,username.text,name.text,number.text, context, scaffoldkey);
                        }


                        // Navigator.push(context,
                        //   MaterialPageRoute(
                        //       builder: (context) => SignUp()),
                        // );
                      },
                      color: Color(0xFFFEB904),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 53.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Create account",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
Spacer()
              ],
            )),
          ),
        ],
      ),
    );
  }
}
