import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_bul/Screen/PostImage.dart';
import 'package:fin_bul/Screen/chat.dart';
import 'package:fin_bul/Widgets/Drawer.dart';
import 'package:fin_bul/Widgets/Switch.dart';
import 'package:fin_bul/Widgets/icons.dart';
import 'package:fin_bul/Widgets/photoView.dart';
import 'package:fin_bul/Service/firebase.dart';
import 'package:fin_bul/Utils/Provider.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fin_bul/Model/post.dart';
import 'package:fin_bul/Model/Profile.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Comment extends StatefulWidget {
  var data;
   Comment(this.data);

  @override
  CommentState createState() => CommentState();
}

class CommentState extends State<Comment> {
  TextEditingController _controller = TextEditingController();

  final  scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var image;
    var comment = 0;

    final picker = ImagePicker();
    void pickImage(
        {@required ImageSource source, @required data,  postId, context}) async {
      var provider = Provider.of<DataProvider>(context, listen: false);
      final selectedImage = await picker.getImage(source: source);
      image = selectedImage;
      print(image);
      image!=null?Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PostImage(image: image, data: data, postId:postId,  page:'comment', comment:provider.productPrice);
      })):null;
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


    DataProvider provide  = Provider.of<DataProvider>(context, listen: false);
    var label = 'None';
    print(provide.firebaseUserId);
    return  Scaffold(
      drawer: Draw(),
      key: scaffoldkey,
    backgroundColor: Color(0xFF372C6A),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65.0, left: 20, right: 20),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.keyboard_backspace_outlined, color: Colors.white,),
                    onPressed: (){
                      Navigator.pop(context);
                    }),
                // Text('finbul',
                //     style: TextStyle(
                //       color: Color(0xFFFEB904),
                //       fontWeight: FontWeight.bold,
                //       fontSize: 25,
                //     )),
                Spacer(),
                IconButton(
                    icon: Icon(
                      Icons.segment,
                      color: Colors.white,
                    ),
                    onPressed: () {
scaffoldkey.currentState.openDrawer();
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Hero(
                tag: 'searchButton',
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 12),
                  margin: const EdgeInsets.only(bottom: 15, top: 15),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      border: Border.all(color: Color(0xFFF1F1FD)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54.withOpacity(0.5),
                            blurRadius: 15.0,
                            offset: Offset(0.3, 1.0))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          FeatherIcons.search,
                          color: Color(0xFF555555),
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF270F33),
                              fontWeight: FontWeight.w600),
                          onChanged: (value) {
                            setState(() {
                              // searchvalue = value;
                              // SearchResult(searchvalue);
                            });
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: 'Find stocks, people and more',
                            hintStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            focusColor: Color(0xFF2B1137),
                            fillColor: Color(0xFF2B1137),
                            hoverColor: Color(0xFF2B1137),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [

                StreamBuilder(
                  stream: FirebaseApi
                      .profileStream(provide.firebaseUserId),
                  builder: (context,
                      AsyncSnapshot<
                          QuerySnapshot>
                      snapshot) {
                    if (snapshot.hasData) {
                      List<Profile> profiles;
                      profiles = snapshot
                          .data.docs
                          .map((doc) =>
                          Profile.fromMap(
                              doc.data(),
                              doc.id))
                          .toList();

                      switch (snapshot
                          .connectionState) {
                        case ConnectionState
                            .waiting:
                          return Center(
                              child:
                              CircularProgressIndicator());
                        default:
                          if (snapshot
                              .hasError) {
                            return Container(
                                padding: EdgeInsets
                                    .only(
                                    left:
                                    20,
                                    right:
                                    20,
                                    top:
                                    15),
                                child: Center(
                                    child: Text(
                                      'Something Went Wrong Try later',
                                      style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                          FontWeight
                                              .bold),
                                    )));
                          } else {
                            final verifiedProfile =
                                profiles;
                            if (verifiedProfile
                                .isEmpty) {
                              return Container();
                            } else
                              return
                                StreamBuilder(
                                  stream: FirebaseApi
                                      .singlePostStream(widget.data.id),
                                  builder: (context,
                                      AsyncSnapshot
                                      snapshots1) {
                                    if (snapshots1.hasData) {
                                      switch (snapshots1
                                          .connectionState) {
                                        case ConnectionState
                                            .waiting:
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        default:
                                          if (snapshots1
                                              .hasError) {
                                            return Container(
                                                padding: EdgeInsets
                                                    .only(
                                                    left:
                                                    20,
                                                    right:
                                                    20,
                                                    top:
                                                    15),
                                                child: Center(
                                                    child: Text(
                                                      'Something Went Wrong Try later',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    )));
                                          } else {
                                            return     Padding(
                                              padding: const EdgeInsets.only(top: 0),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: ListView(
                                                  padding: EdgeInsets.only(left: 0, right: 0, top: 10),
                                                  physics: ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 18, right: 18, top: 0),
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
                                                                    top: 8.0, left: 8, right: 8, bottom: 0),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                      width: MediaQuery.of(context).size.width / 1.6,
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
                                                                          hintStyle: TextStyle(color: Colors.black54),
                                                                          hintText:
                                                                          "Les't chat\ndont forget to add \$ before the ticker e.g \$NTC",
                                                                          focusedBorder: InputBorder.none,
                                                                          enabledBorder: InputBorder.none,
                                                                          errorBorder: InputBorder.none,
                                                                          disabledBorder: InputBorder.none,
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
                                                                            postId: widget.data.id,
                                                                            data: verifiedProfile[0]);
                                                                      },
                                                                      icon: Icon(FeatherIcons.image),
                                                                      color: Colors.black54,
                                                                    ),
                                                                    IconButton(
                                                                      onPressed: () {
                                                                        pickImage(
                                                                          postId: widget.data.id,
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
                                                                  onPressed: () {
                                                                    FocusScopeNode currentFocus =
                                                                    FocusScope.of(context);
                                                                    if (!currentFocus.hasPrimaryFocus) {
                                                                      currentFocus.unfocus();
                                                                    }
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            backgroundColor: Colors.transparent,
                                                                          );
                                                                        });
                                                                    var provider = Provider.of<DataProvider>(context, listen: false);

                                                                    FirebaseApi.uploadpostComment(
                                                                        id: verifiedProfile[0].userid,
                                                                        message: _controller.text,
                                                                        name: verifiedProfile[0].name,
                                                                        username: verifiedProfile[0].username,
                                                                        status: label,
                                                                        picture: verifiedProfile[0].picture,
                                                                        context: context,
                                                                        postid: widget.data.id,
                                                                      scaffoldkey: scaffoldkey,

                                                                    );

                                                                    FirebaseApi.updatePost(widget.data.id, provider.productPrice+1);
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
                                                                          bottomRight: Radius.circular(3))),
                                                                  padding: EdgeInsets.all(0.0),
                                                                  child: Ink(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            bottomLeft: Radius.circular(16),
                                                                            bottomRight: Radius.circular(16))),
                                                                    child: Container(
                                                                      constraints: BoxConstraints(
                                                                          maxWidth: 150.0, minHeight: 50.0),
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
                                              Container(
                                                padding:
                                                EdgeInsets.only(top: 15, bottom: 5, left:20, right: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage: NetworkImage(
                                                              widget.data.picture),
                                                          backgroundColor:
                                                          Color(0xFFFEB904),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 13.0, right: 8),
                                                              child: Text(
                                                                widget.data.name,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                            Text(
                                                              '@${  widget.data.username}',
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  left: 5.0, right: 5),
                                                              child: Icon(
                                                                Icons.circle,
                                                                color: Colors.white,
                                                                size: 4,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${Utils().formatDate2(widget.data.createdAt)}",
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        PopupMenuButton(
                                                          padding: EdgeInsets.all(0),
                                                          elevation: 9,
                                                          icon: Icon(
                                                            Icons.more_horiz_rounded,
                                                            color: Colors.white,
                                                          ),
                                                          onSelected: (result) {
                                                            FirebaseApi.addUserChat(
                                                              urlAvatar2:  verifiedProfile[0].picture,
                                                              name2: verifiedProfile[0].name,
                                                              idArtisan: provide.firebaseUserId,
                                                              artisanMobile:verifiedProfile[0].number,
                                                              userMobile:
                                                              widget.data.phone,
                                                              idUser: widget.data.userid,
                                                              urlAvatar: widget.data.picture,
                                                              name: widget.data.name,
                                                            );
                                                            Navigator.push(context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context, animation, secondaryAnimation) {
                                                                      return ChatPage(
                                                                        user:   widget.data,
                                                                      );
                                                                    },
                                                                     transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },
                                                                    ));
                                                          },
                                                          itemBuilder:
                                                              (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                            const PopupMenuItem(
                                                              value: 'Message',
                                                              child: Text('Message'),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                   widget.data
                                                        .imageSent==null||widget.data
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
                                                            tag:  widget.data
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
                                                                        widget.data
                                                                            .imageSent,
                                                                        widget.data
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
                                                                      widget.data
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
                                                                  widget.data.message,
                                                                  style: TextStyle(
                                                                      color: Colors.white),
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      top: 8.0),
                                                                  child: Row(
                                                                    children: [
                                                                       Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons
                                                                                  .mode_comment_outlined,
                                                                              color: Colors.white,
                                                                              size: 18,
                                                                            ),
                                                                            Text(snapshots1.data['comment'],
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white)),
                                                                          ],
                                                                        ),
                                                                      SizedBox(
                                                                        width: 20,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:(){
                                                                          FirebaseApi.thumbUpPost(number:int.parse(snapshots1.data['uplike'])+1,id:widget.data.id);
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              FeatherIcons.thumbsUp,
                                                                              color: Colors.white,
                                                                              size: 18,
                                                                            ),
                                                                            Text(
                                                                                snapshots1.data['uplike'],
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
                                                                        onTap:(){
                                                                          FirebaseApi.thumbDownPost(number:int.parse(snapshots1.data['downlike'])+1,id:widget.data.id);
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              FeatherIcons.thumbsDown,
                                                                              color: Colors.white,
                                                                              size: 18,
                                                                            ),
                                                                            Text(
                                                                                snapshots1.data['downlike'],
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 20,
                                                                      ),
                                                                      Padding(
                                                                        padding:  EdgeInsets.only(bottom:   snapshots1.data['status']=='Bull' ||  snapshots1.data['status']=='Bear'? 8.0:0),
                                                                        child: Icon(
                                                                          snapshots1.data['status']=='Bear'? MyFlutterApp.bear
                                                                              : snapshots1.data['status']=='Bull'? MyFlutterApp.bull
                                                                              :Icons
                                                                              .sentiment_neutral,
                                                                          color: snapshots1.data['status']=='Bear'? Colors
                                                                              .red
                                                                              :  snapshots1.data['status']=='Bull'? Colors
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
                                                                          FlutterClipboard.copy(snapshots1.data['message']).then(( value ) =>  scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('copied'))));
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
                                                                ),
                                                                StreamBuilder(
                                                                  stream: FirebaseApi
                                                                      .postCommentStream(
                                                                      widget.data.id
                                                                  ),
                                                                  builder: (context,
                                                                      AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                    if (snapshot.hasData) {
                                                                      List<Post> posts1;
                                                                      posts1 = snapshot
                                                                          .data.docs
                                                                          .map((doc) =>
                                                                          Post.fromMap(
                                                                              doc.data(),
                                                                              doc.id))
                                                                          .toList();

                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                            .waiting:
                                                                          return Center(
                                                                              child:
                                                                              CircularProgressIndicator());
                                                                        default:
                                                                          if (snapshot
                                                                              .hasError) {
                                                                            return Container(
                                                                                padding: EdgeInsets
                                                                                    .only(
                                                                                    left:
                                                                                    20,
                                                                                    right:
                                                                                    20,
                                                                                    top:
                                                                                    15),
                                                                                child: Center(
                                                                                    child: Text(
                                                                                      'Something Went Wrong Try later',
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .white,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .bold),
                                                                                    )));
                                                                          } else {
                                                                            final verifiedPostsComment =
                                                                                posts1;
                                                                            var provider = Provider.of<DataProvider>(context, listen: true);
                                                                               provider.setProductPrice(verifiedPostsComment.length);

                                                                            if (verifiedPostsComment
                                                                                .isEmpty) {
                                                                              return Container();
                                                                            } else
                                                                              return ListView
                                                                                  .builder(
                                                                                  physics:
                                                                                  ScrollPhysics(),
                                                                                  itemCount: verifiedPostsComment.length >=
                                                                                      3
                                                                                      ? 3
                                                                                      : verifiedPostsComment
                                                                                      .length,
                                                                                  shrinkWrap:
                                                                                  true,
                                                                                  itemBuilder:
                                                                                      (context,
                                                                                      index) {


                                                                                    return  Container(
                                                                                      padding: EdgeInsets.only(top: 8, bottom: 5),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              CircleAvatar(
                                                                                                radius: 25,
                                                                                                backgroundImage: NetworkImage(verifiedPostsComment[index].picture),
                                                                                                backgroundColor: Color(0xFFFEB904),
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 6.0, right: 4),
                                                                                                    child: Text(
                                                                                                      verifiedPostsComment[index].name,
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    '@${verifiedPostsComment[index].username}',
                                                                                                    style: TextStyle(color: Colors.white),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 2.0, right: 2),
                                                                                                    child: Icon(
                                                                                                      Icons.circle,
                                                                                                      color: Colors.white,
                                                                                                      size: 4,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "${Utils().formatDate2(verifiedPostsComment[index].createdAt)}",
                                                                                                    style: TextStyle(color: Colors.white),
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
                                                                                                        verifiedPostsComment[index].message,
                                                                                                        style: TextStyle(color: Colors.white),
                                                                                                      ),
                                                                                                      Padding(
                                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                                        child: Row(
                                                                                                          children: [

                                                                                      //  FirebaseApi.thumbUp(number:int.parse(verifiedPostsComment[index].thumbup)+1,id: verifiedPostsComment[index].id);
                                                                                                           InkWell(
                                                                                                             onTap:(){
                                                                                                               FirebaseApi.thumbUp(number:int.parse(verifiedPostsComment[index].thumbup)+1,id: verifiedPostsComment[index].id);
                                                                                                             },
                                                                                                             child: Row(
                                                                                                               children: [
                                                                                                                 Icon(
                                                                                                                   FeatherIcons.thumbsUp,
                                                                                                                   color: Colors.white,
                                                                                                                   size: 18,
                                                                                                                 ),
                                                                                                                 Text(verifiedPostsComment[index].thumbup, style: TextStyle(color: Colors.white)),
                                                                                                               ],
                                                                                                             ),
                                                                                                           ),
                                                                                                            SizedBox(
                                                                                                              width: 20,
                                                                                                            ),
                                                                                                           InkWell(
                                                                                                             onTap:(){
                                                                                                               FirebaseApi.thumbDown(number:int.parse(verifiedPostsComment[index].thumbdown)+1,id: verifiedPostsComment[index].id);
                                                                                                             },
                                                                                                             child: Row(
                                                                                                               children: [
                                                                                                                 Icon(
                                                                                                                   FeatherIcons.thumbsDown,
                                                                                                                   color: Colors.white,
                                                                                                                   size: 18,
                                                                                                                 ),
                                                                                                                 Text(verifiedPostsComment[index].thumbdown, style: TextStyle(color: Colors.white)),
                                                                                                               ],
                                                                                                             ),
                                                                                                           ),
                                                                                                            SizedBox(
                                                                                                              width: 20,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding:  EdgeInsets.only(bottom: verifiedPostsComment[index].status=='Bull' ||verifiedPostsComment[index].status=='Bear'? 8.0:0),
                                                                                                              child: Icon(
                                                                                                                verifiedPostsComment[index].status=='Bear'? MyFlutterApp.bear
                                                                                                                    : verifiedPostsComment[index].status=='Bull'? MyFlutterApp.bull
                                                                                                                    :Icons
                                                                                                                    .sentiment_neutral,
                                                                                                                color:verifiedPostsComment[index].status=='Bear'? Colors
                                                                                                                    .red
                                                                                                                    : verifiedPostsComment[index].status=='Bull'? Colors
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
                                                                                                                FlutterClipboard.copy(verifiedPostsComment[index]
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
                                                                      return Center(
                                                                          child:
                                                                          CircularProgressIndicator());
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                                  ],
                                                ),
                                              ),
                                            );

                                          }
                                      }
                                    } else {
                                      return Center(
                                          child:
                                          CircularProgressIndicator());
                                    }
                                  },
                                );


                          }
                      }
                    } else {
                      return Center(
                          child:
                          CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );



  }
}
