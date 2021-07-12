import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';



class RecoverPass extends StatefulWidget {
  const RecoverPass({Key key}) : super(key: key);

  @override
  _RecoverPassState createState() => _RecoverPassState();
}



class _RecoverPassState extends State<RecoverPass>{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<EmailSignInProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF372C6A),
      key: _scaffoldKey,
      drawer: Draw(),
      appBar: AppBar(
        backgroundColor: Color(0xFF372C6A),
          title: const Text('Reset Password'),
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.segment,
                  color: Colors.white,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                })
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              size: 20,
              color: Colors.white,
            ),
          )),
      body: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Icon(
                    Icons.autorenew,
                    color:Color(0xFFFEB904),
                    size: 140,
                  )),
              Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          )),

                           Container(
                        height: 55,
                        alignment: Alignment.center,
                        padding:
                        const EdgeInsets.only(
                            left: 12),
                        margin: const EdgeInsets.only(
                            bottom: 15,
                            left: 12,
                            right: 12,
                            top: 5),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            // border: isAppEmpty ? Border.all(color: Colors.red) : null,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 15.0,
                                  offset: Offset(
                                      0.3, 4.0))
                            ],
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    7))),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                  right: 10),
                              child: Icon(
                                Icons.email,
                                color:
                                Color(0xFF555555),
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                               controller: controller,
                                keyboardType:
                                TextInputType
                                    .emailAddress,
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return 'Email cannot be blank';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontFamily:
                                    'Firesans',
                                    fontSize: 16,
                                    color: Color(
                                        0xFF270F33),
                                    fontWeight:
                                    FontWeight
                                        .w600),
                                //controller: expiryDate,
                                decoration:
                                InputDecoration
                                    .collapsed(
                                  hintText:
                                  'Enter Email',
                                  hintStyle: TextStyle(
                                      fontFamily:
                                      'Firesans',
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight
                                          .w600),
                                  focusColor: Color(
                                      0xFF2B1137),
                                  fillColor: Color(
                                      0xFF2B1137),
                                  hoverColor: Color(
                                      0xFF2B1137),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 34),
                        child: Center(
                          child: Container(
                            child: FlatButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  FirebaseApi.sendPassWordResetEmail(controller.text, _scaffoldKey, context);

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
                                      maxWidth: 250.0, minHeight: 53.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "FORGET PASSWORD",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
