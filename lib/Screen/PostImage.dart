import 'dart:io';

import 'package:fin_bul/Service/firebase.dart';
import 'package:fin_bul/Widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PostImage extends StatelessWidget {
  var data;
  var image;
  var postId;
  var comment;
  var page;

  PostImage({this.data, this.image, this.postId, this.page, this.comment});

  TextEditingController _controller = TextEditingController();
  var label = 'None';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color(0xFF372C6A),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.686,
            child: Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return ToggleSwitch(
                minWidth: MediaQuery.of(context).size.width / 3,
                minHeight: 40.0,
                initialLabelIndex: 1,
                activeBgColor: [Colors.green],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.grey[900],
                cornerRadius: 0.0,
                totalSwitches: 3,
                icons: [
                  MyFlutterApp.bear,
                  Icons.sentiment_neutral,
                  MyFlutterApp.bull
                ],
                // labels: ['America', 'Canada', 'Mexico'],
                onToggle: (index) {
                  if (index == 0) {
                    label = 'Bear';
                  } else if (index == 1) {
                    label = 'None';
                  } else {
                    label = 'Bull';
                  }
                  print('switched to: $label');
                },
              );
            }
          ),
          Container(
            color: Colors.black54,
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: _controller,
              // onChanged: (val) {
              //   (val.length > 0 && val.trim() != "")
              //       ? datas.setWritingTo(true)
              //       : datas.setWritingTo(false);
              //
              //   message = val;
              //   setState(() {
              //     print(message);
              //   });
              // },
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              autofocus: false,
              // focusNode: textFieldFocus,
              enableSuggestions: true,
              style: TextStyle(color: Colors.white),
              maxLines: null,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right:8.0, top:30),
                  child: InkWell(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      page=='feed'?FirebaseApi.uploadPost2(
                          id: data.userid,
                          message: _controller.text,
                          name: data.name,
                          phone: data.number,
                          username:
                          data.username,
                          status: label,
                          picture:
                          data.picture,

                          image: image,
                          context: context).then((value){
                        Navigator.pop(context);
                        _controller.clear();
                      }) : FirebaseApi.uploadComment2(
                          id: data.userid,
                          image: image,
                          message: _controller.text,
                          name: data.name,
                          username: data.username,
                          status: label,
                          picture:data.picture,
                          context: context,
                          postid: postId).then((value){
                        Navigator.pop(context);
                        _controller.clear();
                      });
                      FirebaseApi.updatePost(postId.toString(), comment+1);

                    },
                    child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFFEB904), shape: BoxShape.circle),
                            child: Center(
                              child:Icon(FeatherIcons.send, color: Colors.white,)
                            )),
                  ),
                ),

                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
                hintText:
                    "Les't chat\ndont forget to add \$ before the ticker e.g \$NTC",
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                filled: true,
                //fillColor: Colors.black38,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
