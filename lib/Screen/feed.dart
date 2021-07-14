import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finbul/Screen/PostImage.dart';
import 'package:finbul/Screen/chat.dart';
import 'package:finbul/Screen/comment.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:finbul/Widgets/Switch.dart';
import 'package:finbul/Widgets/icons.dart';
import 'package:finbul/Widgets/photoView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finbul/Model/post.dart';
import 'package:finbul/Model/Profile.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class Feed extends StatefulWidget {
  const Feed({Key key}) : super(key: key);

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> {
  TextEditingController _controller = TextEditingController();
  final  scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DataProvider provide = Provider.of<DataProvider>(context, listen: false);
    var label = 'None';
    var image;

    final picker = ImagePicker();
    void pickImage(
        {@required ImageSource source, @required data, context}) async {
      final selectedImage = await picker.getImage(source: source);
      image = selectedImage;
      print(image);
     image!=null? Navigator.push(context,  PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation){
        return PostImage(image: image, data: data, page:'feed');
      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },)):null;
      // FocusScope.of(context).unfocus();
      // // _controller2.clear();
      // _controller.clear();
      // datas.setWritingTo(false);
      // await FirebaseApi.uploadImage(
      //     widget.user.userid.toString(),
      //     network.firebaseUserId,
      //     selectedImage,
      //     context,
      //     '${network.firebaseUserId}-${widget.user.userid.toString()}')
      //     .then((value) {
      //   Navigator.pop(context);
      // });
    }

    return Scaffold(
      key:scaffoldkey,
      backgroundColor: Color(0xFF372C6A),
      body: StreamBuilder(
        stream: FirebaseApi.profileStream(provide.firebaseUserId),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Profile> profiles;
            profiles = snapshot.data.docs
                .map((doc) => Profile.fromMap(doc.data(), doc.id))
                .toList();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
              default:
                if (snapshot.hasError) {
                  return Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Center(
                          child: Text(
                        'Something Went Wrong Try later',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                } else {
                  final verifiedProfile = profiles;
                  if (verifiedProfile.isEmpty) {
                    return Container();
                  } else {
                    provide.setFirstName(verifiedProfile[0].name);
                    return Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView(
                          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 18, right: 18, top: 0),
                              child: Container(
                                height: 234,
                                child: Card(
                                  child: ListView(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8,
                                            right: 8,
                                            bottom: 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  verifiedProfile[0].picture),
                                              backgroundColor: Color(0xFFFEB904),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              height: 120,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.6,
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
                                                textCapitalization:
                                                    TextCapitalization.sentences,
                                                autocorrect: true,
                                                autofocus: false,
                                                // focusNode: textFieldFocus,
                                                enableSuggestions: true,
                                                maxLines: null,

                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54),
                                                  hintText:
                                                      "Les't chat\ndont forget to add \$ before the ticker e.g \$NTC",
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.help,
                                              color: Color(0xFFFEB904),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3.5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                pickImage(
                                                    source: ImageSource.gallery,
                                                    context: context,
                                                    data: verifiedProfile[0]);
                                              },
                                              icon: Icon(FeatherIcons.image),
                                              color: Colors.black54,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                pickImage(
                                                    source: ImageSource.camera,
                                                    context: context,
                                                    data: verifiedProfile[0]);
                                              },
                                              icon: Icon(FeatherIcons.camera),
                                              color: Colors.black54,
                                            ),
                                            CustomSlider(
                                              valueChanged: (v) {
                                                if (v == Status.right) {
                                                  label = 'Bear';
                                                } else if (v == Status.none) {
                                                  label = 'None';
                                                } else {
                                                  label = 'Bull';
                                                }
                                              },
                                            ),
                                            // ToggleSwitch(
                                            //   minWidth: 60.0,
                                            //   minHeight: 30.0,
                                            //   initialLabelIndex: 1,
                                            //   activeBgColor: [Colors.green],
                                            //   activeFgColor: Colors.white,
                                            //   inactiveBgColor: Colors.grey,
                                            //   inactiveFgColor: Colors.grey[900],
                                            //   totalSwitches: 3,
                                            //   icons: [
                                            //     MyFlutterApp.bear,
                                            //     Icons.sentiment_neutral,
                                            //     MyFlutterApp.bull
                                            //   ],
                                            //   // labels: ['America', 'Canada', 'Mexico'],
                                            //   onToggle: (index) {
                                            //     if (index == 0) {
                                            //       label = 'Bear';
                                            //     } else if (index == 1) {
                                            //       label = 'None';
                                            //     } else {
                                            //       label = 'Bull';
                                            //     }
                                            //     print('switched to: $label');
                                            //   },
                                            // ),
                                            SizedBox(
                                              width: 10,
                                            ),

                                            // SizedBox(
                                            //   width: 15,
                                            // ),
                                            // Icon(
                                            //   Icons.bar_chart_outlined,
                                            //   color: Colors.black54,
                                            // ),
                                            // SizedBox(
                                            //   width: 45,
                                            // ),
                                            // Icon(
                                            //   FeatherIcons.eyeOff,
                                            //   color: Colors.black54,
                                            // ),

                                            // StatefulBuilder(
                                            //   builder: (context, setState) {
                                            //     bool status = false;
                                            //     return Switch(
                                            //         value: status, onChanged: (value) {
                                            //       print("VALUE : $value");
                                            //       setState(() {
                                            //         status = value;
                                            //       });
                                            //     });
                                            //   }
                                            // ),
                                            // Icon(
                                            //   FeatherIcons.eye,
                                            //   color: Colors.black54,
                                            // ),
                                          ],
                                        ),
                                      ),
                                      //    _controller.text.isEmpty?null:

                                      Container(
                                        child: FlatButton(
                                          disabledColor: Color(0xFFFEB904),
                                          onPressed: _controller.text.isEmpty?(){
                                            scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Field cannot be empty!'),));
                                          }
                                          :() {
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
                                 child:  CupertinoActivityIndicator(),
                                  backgroundColor: Colors.transparent,
                                );
                              });


                                            FirebaseApi.uploadpost(
                                                id: verifiedProfile[0].userid,
                                                message: _controller.text,
                                                name: verifiedProfile[0].name,
                                                phone: verifiedProfile[0].number,
                                                username:
                                                    verifiedProfile[0].username,
                                                status: label,
                                                picture:
                                                    verifiedProfile[0].picture,
                                                context: context,
                                            scaffoldkey: scaffoldkey,
                                            );
                                            // Navigator.push(context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) => SignUp()),
                                            // );
                                            _controller.clear();
                                          },
                                          color: Color(0xFFFEB904),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(3),
                                                  bottomRight:
                                                      Radius.circular(3))),
                                          padding: EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16))),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 150.0,
                                                  minHeight: 50.0),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Post",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseApi.postStream(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                List<Post> posts;
                                if (snapshot.hasData) {
                                  posts = snapshot.data.docs
                                      .map((doc) =>
                                          Post.fromMap(doc.data(), doc.id))
                                      .toList();

                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
                                    default:
                                      if (snapshot.hasError) {
                                        return Container(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20, top: 15),
                                            child: Center(
                                                child: Text(
                                              'Something Went Wrong Try later',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )));
                                      } else {
                                        final verifiedPosts = posts;
                                        if (verifiedPosts.isEmpty) {
                                          return Container(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20, top: 15),
                                              child: Center(
                                                  child: Text('No Post Found',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold))));
                                        } else
                                          return Container(
                                              child: ListView.builder(
                                                padding: EdgeInsets.only(top: 15),
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: verifiedPosts.length,
                                                itemBuilder: (context, index1) {
                                                  return Container(
                                                    color: index1.isEven
                                                        ? Color(0xFF403477)
                                                        : Color(0xFF372C6A),
                                                    padding: EdgeInsets.only(
                                                        top: 15, bottom: 5, left: 20, right: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      verifiedPosts[
                                                                              index1]
                                                                          .picture),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFFFEB904),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              13.0,
                                                                          right:
                                                                              8),
                                                                  child: Text(
                                                                    verifiedPosts[
                                                                            index1]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '@${verifiedPosts[index1].username}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5.0,
                                                                          right:
                                                                              5),
                                                                  child: Icon(
                                                                    Icons.circle,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 4,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${Utils().formatDate2(verifiedPosts[index1].createdAt)}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            PopupMenuButton(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      0),
                                                              elevation: 9,
                                                              icon: Icon(
                                                                Icons
                                                                    .more_horiz_rounded,
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                              onSelected:
                                                                  (result) {
                                                                FirebaseApi
                                                                    .addUserChat(
                                                                  urlAvatar2:
                                                                      verifiedProfile[
                                                                              0]
                                                                          .picture,
                                                                  name2:
                                                                      verifiedProfile[
                                                                              0]
                                                                          .name,
                                                                  idArtisan: provide
                                                                      .firebaseUserId,
                                                                  artisanMobile:
                                                                      verifiedProfile[
                                                                              0]
                                                                          .number,
                                                                  userMobile:
                                                                      verifiedPosts[
                                                                              index1]
                                                                          .phone,
                                                                  idUser:
                                                                      verifiedPosts[
                                                                              index1]
                                                                          .userid,
                                                                  urlAvatar:
                                                                      verifiedPosts[
                                                                              index1]
                                                                          .picture,
                                                                  name: verifiedPosts[
                                                                          index1]
                                                                      .name,
                                                                );
                                                                Navigator.push(
                                                                    context,
                                                                    PageRouteBuilder(
                                                                      pageBuilder: (context, animation, secondaryAnimation) {
                                                                  return ChatPage(
                                                                    user: verifiedPosts[
                                                                        index1],
                                                                  );
                                                                }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                                                              },
                                                              itemBuilder: (BuildContext
                                                                      context) =>
                                                                  <PopupMenuEntry>[
                                                                const PopupMenuItem(
                                                                  value:
                                                                      'Message',
                                                                  child: Text(
                                                                      'Message'),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        verifiedPosts[index1]
                                                            .imageSent==null||verifiedPosts[index1]
                                                            .imageSent.toString().isEmpty?Container():Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 60,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 4.0),
                                                              child: Hero(
                                                                tag: verifiedPosts[
                                                                        index1]
                                                                    .imageSent,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    return Navigator
                                                                        .push(
                                                                      context,
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation) {
                                                                          return PhotoView(
                                                                            verifiedPosts[index1]
                                                                                .imageSent,
                                                                            verifiedPosts[index1]
                                                                                .imageSent,
                                                                          );
                                                                        },
                                                                        transitionsBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation,
                                                                            child) {
                                                                          return FadeTransition(
                                                                            opacity:
                                                                                animation,
                                                                            child:
                                                                                child,
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 170,
                                                                    width: 170,
                                                                    child: Card(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                3.0),
                                                                        child: Image
                                                                            .network(
                                                                          verifiedPosts[index1]
                                                                              .imageSent,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 60,
                                                            ),
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  verifiedPosts[
                                                                          index1]
                                                                      .message,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),

                                                                Consumer<
                                                                        DataProvider>(
                                                                    // selector: (_,
                                                                    //         provider) =>
                                                                    //     provider
                                                                    //         .selected,
                                                                    builder: (context,
                                                                        selected,
                                                                        child) {
                                                                  return Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                            8.0),
                                                                        child: Row(
                                                                          children: [
                                                                          
                                                                              Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed:
                                                                                  () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    PageRouteBuilder(
                                                                                      pageBuilder: (context, animation, secondaryAnimation){
                                                                                      return Comment(
                                                                                          verifiedPosts[index1]);
                                                                                    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                                                                                //  _Comment(verifiedPosts[index].id);
                                                                              },
                                                                                   icon:Icon( Icons.mode_comment_outlined,
                                                                                    color:
                                                                                    Colors.white,
                                                                                    size:
                                                                                    18,
                                                                                   )
                                                                                  ),
                                                                                  Text(
                                                                                      verifiedPosts[index1].comment,
                                                                                      style: TextStyle(color: Colors.white)),
                                                                                ],
                                                                              ),
                                                                            

                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            
                                                                              Row(
                                                                                 
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed:
                                                                                  () {
                                                                                FirebaseApi.thumbUpPost(
                                                                                    number:
                                                                                    int.parse(verifiedPosts[index1].thumbup) + 1,
                                                                                    id: verifiedPosts[index1].id);
                                                                              },

                                                                                   icon: Icon(FeatherIcons.thumbsUp,
                                                                                    color:
                                                                                    Colors.white,
                                                                                    size:
                                                                                    18,
                                                                                  )),
                                                                                  Text(
                                                                                      verifiedPosts[index1].thumbup,
                                                                                      style: TextStyle(color: Colors.white)),
                                                                                ],
                                                                              ),
                                                                            
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            
                                                                              Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed:
                                                                                  () {
                                                                                FirebaseApi.thumbDownPost(
                                                                                    number:
                                                                                    int.parse(verifiedPosts[index1].thumbdown) + 1,
                                                                                    id: verifiedPosts[index1].id);
                                                                              },
                                                                                    icon:Icon(
                                                                                    FeatherIcons.thumbsDown,
                                                                                    color:
                                                                                    Colors.white,
                                                                                    size:
                                                                                    18,
                                                                                  )),
                                                                                  Text(
                                                                                      verifiedPosts[index1].thumbdown,
                                                                                      style: TextStyle(color: Colors.white)),
                                                                                ],
                                                                              ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),


                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    onPressed:
                                                                                        () {
                                                                                      FlutterClipboard.copy(verifiedPosts[index1]
                                                                                          .message).then(( value ) =>  scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('copied'))));
                                                                                    },
                                                                                    icon:Icon(
                                                                                      Icons
                                                                                          .copy,
                                                                                      color: Colors
                                                                                          .white,
                                                                                      size: 18,
                                                                                    ))
                                                                                ,
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Padding(
                                                                              padding:  EdgeInsets.only(bottom: verifiedPosts[index1].status=='Bull' ||verifiedPosts[index1].status=='Bear'? 8.0:0),
                                                                              child: Icon(
                                                                                verifiedPosts[index1].status ==
                                                                                    'Bear'
                                                                                    ? MyFlutterApp
                                                                                    .bear
                                                                                    : verifiedPosts[index1].status == 'Bull'
                                                                                    ? MyFlutterApp.bull
                                                                                    : Icons.sentiment_neutral,
                                                                                color: verifiedPosts[index1].status=='Bear'? Colors
                                                                                    .red
                                                                                    :  verifiedPosts[index1].status=='Bull'? Colors
                                                                                    .green
                                                                                    :Colors
                                                                                    .white,
                                                                                size: 24,
                                                                              ),
                                                                            ),

                                                                            
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // subComment(
                                                                      //     data: verifiedPosts[
                                                                      //         index1], scaffoldkey: scaffoldkey,)
                                                                    ],
                                                                  );
                                                                }),
                                                              ],
                                                            )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ));
                                      }
                                  }
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
            }
          } else {
            return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
          }
        },
      ),
    );
  }
}

class subComment extends StatelessWidget {
  var data;
  var scaffoldkey;

  subComment({this.data, this.scaffoldkey});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseApi.postCommentStream(data.id),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Post> posts1;
          posts1 = snapshot.data.docs
              .map((doc) => Post.fromMap(doc.data(), doc.id))
              .toList();

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
            default:
              if (snapshot.hasError) {
                return Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Center(
                        child: Text(
                      'Something Went Wrong Try later',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )));
              } else {
                final verifiedPostsComment = posts1;
                if (verifiedPostsComment.isEmpty) {
                  return Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Center(
                          child: Text(
                        'No Comment',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                } else
                  return ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: verifiedPostsComment.length >= 3
                          ? 3
                          : verifiedPostsComment.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return index == 2
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation){
                                    return Comment(data);
                                  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'See more comment',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.only(top: 8, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              verifiedPostsComment[index]
                                                  .picture),
                                          backgroundColor: Color(0xFFFEB904),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0, right: 4),
                                              child: Text(
                                                verifiedPostsComment[index]
                                                    .name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              '@${verifiedPostsComment[index].username}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.white,
                                                size: 4,
                                              ),
                                            ),
                                            Text(
                                              "${Utils().formatDate2(verifiedPostsComment[index].createdAt)}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.more_horiz_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    verifiedPostsComment[index]
                                        .imageSent==null|| verifiedPostsComment[index]
                                        .imageSent.toString().isEmpty?Container():Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              top: 4.0),
                                          child: Hero(
                                            tag:  verifiedPostsComment[index]
                                                .imageSent,
                                            child:
                                            GestureDetector(
                                              onTap: () {
                                                return Navigator
                                                    .push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return PhotoView(
                                                        verifiedPostsComment[index]
                                                            .imageSent,
                                                        verifiedPostsComment[index]
                                                            .imageSent,
                                                      );
                                                    },
                                                    transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) {
                                                      return FadeTransition(
                                                        opacity:
                                                        animation,
                                                        child:
                                                        child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child:
                                              Container(
                                                height: 170,
                                                width: 170,
                                                child: Card(
                                                  child:
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        3.0),
                                                    child: Image
                                                        .network(
                                                      verifiedPostsComment[index]
                                                          .imageSent,
                                                      fit: BoxFit
                                                          .cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              verifiedPostsComment[index]
                                                  .message,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Row(
                                                children: [
                                                  // Icon(
                                                  //   Icons.mode_comment_outlined,
                                                  //   color: Colors.white,
                                                  //   size: 18,
                                                  // ),
                                                  // Text('12', style: TextStyle(color: Colors.white)),



                                                  // FirebaseApi.thumbUp(number:int.parse(verifiedPosts[index].thumbdown)+1,id: verifiedPosts[index].id);
                                                  InkWell(
                                                    onTap: () {
                                                      FirebaseApi.thumbUp(
                                                          number: int.parse(
                                                                  verifiedPostsComment[
                                                                          index]
                                                                      .thumbup) +
                                                              1,
                                                          id: verifiedPostsComment[
                                                                  index]
                                                              .id);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          FeatherIcons.thumbsUp,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                        Text(
                                                            verifiedPostsComment[
                                                                    index]
                                                                .thumbup,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  InkWell(
                                                    child: Row(children: [
                                                      Icon(
                                                        FeatherIcons.thumbsDown,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      Text(
                                                          verifiedPostsComment[
                                                                  index]
                                                              .thumbdown,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ]),
                                                    onTap: () {
                                                      FirebaseApi.thumbDown(
                                                          number: int.parse(
                                                                  verifiedPostsComment[
                                                                          index]
                                                                      .thumbdown) +
                                                              1,
                                                          id: verifiedPostsComment[
                                                                  index]
                                                              .id);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Padding(
                                                    padding:  EdgeInsets.only(bottom: verifiedPostsComment[
                                                    index]
                                                        .status =='Bull' ||verifiedPostsComment[
                                                    index]
                                                        .status =='Bear'? 8.0:0),
                                                    child: Icon(
                                                      verifiedPostsComment[index]
                                                                  .status ==
                                                              'Bear'
                                                          ? MyFlutterApp.bear
                                                          : verifiedPostsComment[
                                                                          index]
                                                                      .status ==
                                                                  'Bull'
                                                              ? MyFlutterApp.bull
                                                              : Icons.sentiment_neutral,
                                                      color: verifiedPostsComment[index].status=='Bear'? Colors
                                                          .red
                                                          :  verifiedPostsComment[index].status=='Bull'? Colors
                                                          .green
                                                          :Colors
                                                          .white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),

                                                  InkWell(
                                                    onTap:
                                                        () {
                                                      FlutterClipboard.copy(verifiedPostsComment[
                                                      index]
                                                          .message).then(( value ) =>  scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('copied'))));
                                                    },
                                                    child:
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .copy,
                                                          color: Colors
                                                              .white,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              );
                      });
              }
          }
        } else {
          return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
        }
      },
    );
  }
}
