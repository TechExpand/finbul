import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finbul/Model/Profile.dart';
import 'package:finbul/Model/post.dart';
import 'package:finbul/Screen/MyChats.dart';
import 'package:finbul/Screen/PostImage.dart';
import 'package:finbul/Screen/Ranking.dart';
import 'package:finbul/Screen/SearchPage.dart';
import 'package:finbul/Screen/WatchList.dart';
import 'package:finbul/Screen/chat.dart';
import 'package:finbul/Screen/comment.dart';
import 'package:finbul/Screen/feed.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Widgets/icons.dart';
import 'package:finbul/Widgets/photoView.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:finbul/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import 'Home.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key key}) : super(key: key);

  @override
  ProfilesState createState() => ProfilesState();
}

class ProfilesState extends State<Profiles>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final scafoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider provide = Provider.of<DataProvider>(context, listen: false);

    final picker = ImagePicker();
    void pickImage({@required ImageSource source, id, context}) async {
      final selectedImage = await picker.getImage(source: source);
      FirebaseApi.updateImage(id, selectedImage, context);
    }

    final picker2 = ImagePicker();
    void pickImage2({@required ImageSource source, id, context}) async {
      final selectedImage = await picker2.getImage(source: source);
      FirebaseApi.updateCoverImage(id, selectedImage, context);
    }

    return Scaffold(
      drawer: Draw(),
      appBar:AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF372C6A),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace,
              size: 20,
              color: Colors.white,
            ),
          )
      ),
      key: scafoldKey,
      backgroundColor: Color(0xFF372C6A),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Column(
            children: [
              Container(
                child: StreamBuilder(
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
                            final verifiedProfile = profiles;
                            if (verifiedProfile.isEmpty) {
                              return Container();
                            } else {
                              provide.setFirstName(verifiedProfile[0].name);
                              return Stack(
                                children: [
                                  Container(
                                    height: 160,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              verifiedProfile[0].coverImage)),
                                      color: Color(0xFFFEB904),
                                    ),
                                  ),
                                  Positioned(
                                    top: 130,
                                    left: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Container(
                                      height: 25,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          color: Colors.white,
                                          onPressed: () {
                                            pickImage2(
                                                context: context,
                                                source: ImageSource.gallery,
                                                id: verifiedProfile[0].id);
                                          },
                                          iconSize: 20,
                                          icon: Icon(FeatherIcons.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, right: 14, top: 20),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons
                                                    .keyboard_backspace_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            scafoldKey.currentState
                                                .openDrawer();
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons.segment,
                                                color: Colors.white,
                                                size: 25,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ListView(
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 10),
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                          Container(
                                            child: Row(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 4,
                                                            color: Color(
                                                                0xFF372C6A),
                                                          ),
                                                          color:
                                                              Color(0xFF372C6A),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                verifiedProfile[
                                                                        0]
                                                                    .picture),
                                                        backgroundColor:
                                                            Color(0xFFFEB904),
                                                      ),
                                                    ),
                                                    Text(
                                                      verifiedProfile[0].name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      '@${verifiedProfile[0].username}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.date_range,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(width: 3),
                                                          Text(
                                                            'Joined ${Utils().formatDateprofile(verifiedProfile[0].createdAt)}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                              //SizedBox(width: 200,),

                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 70.0),
                                                height: 25,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: Center(
                                                  child: IconButton(
                                                    padding: EdgeInsets.all(0),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      pickImage(
                                                          context: context,
                                                          source: ImageSource
                                                              .gallery,
                                                          id: verifiedProfile[0]
                                                              .id);
                                                    },
                                                    iconSize: 20,
                                                    icon: Icon(
                                                        FeatherIcons.camera),
                                                  ),
                                                ),
                                              ),

                                              IconButton(
                                                padding: const EdgeInsets.only(
                                                    right: 40.0),
                                                color: Colors.white,
                                                onPressed: () {
                                                  _showEditNameModal(
                                                      context,
                                                      verifiedProfile[0].userid,
                                                      verifiedProfile[0].name);
                                                },
                                                icon: Icon(FeatherIcons.edit),
                                              )
                                            ]),
                                          ),
                                          Divider(),
                                          Container(
                                            child: StreamBuilder(
                                              stream: FirebaseApi.mypostStream(
                                                  verifiedProfile[0].userid),
                                              builder: (context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                List<Post> posts;
                                                if (snapshot.hasData) {
                                                  posts = snapshot.data.docs
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
                                                              CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    top: 15),
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
                                                        final verifiedPosts =
                                                            posts;
                                                        if (verifiedPosts
                                                            .isEmpty) {
                                                          return Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      top: 15),
                                                              child: Center(
                                                                  child: Text(
                                                                      'No Post Found',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold))));
                                                        } else
                                                          return Container(


                                                              child: ListView
                                                                  .builder(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            15),
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    ScrollPhysics(),
                                                                itemCount:
                                                                    verifiedPosts
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index1) {
                                                                  return Container(

                                                                    color: index1.isEven
                                                                        ? Color(0xFF403477)
                                                                        : Color(0xFF372C6A),
                                                                    padding: EdgeInsets.only(
                                                                        top: 15,
                                                                        bottom:
                                                                            5,left: 20,
                                                                        right:
                                                                        20),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              radius: 25,
                                                                              backgroundImage: NetworkImage(verifiedPosts[index1].picture),
                                                                              backgroundColor: Color(0xFFFEB904),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 13.0, right: 8),
                                                                                  child: Text(
                                                                                    verifiedPosts[index1].name,
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  '@${verifiedPosts[index1].username}',
                                                                                  style: TextStyle(color: Colors.white),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                                                                                  child: Icon(
                                                                                    Icons.circle,
                                                                                    color: Colors.white,
                                                                                    size: 4,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "${Utils().formatDate2(verifiedPosts[index1].createdAt)}",
                                                                                  style: TextStyle(color: Colors.white),
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
                                                                                FirebaseApi.deletePost(verifiedPosts[index1].id);
                                                                              },
                                                                              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                                                const PopupMenuItem(
                                                                                  value: 'Delete',
                                                                                  child: Text('Delete Post'),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        verifiedPosts[index1].imageSent == null ||
                                                                                verifiedPosts[index1].imageSent.toString().isEmpty
                                                                            ? Container()
                                                                            : Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 60,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 4.0),
                                                                                    child: Hero(
                                                                                      tag: verifiedPosts[index1].imageSent,
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          return Navigator.push(
                                                                                            context,
                                                                                            PageRouteBuilder(
                                                                                              pageBuilder: (context, animation, secondaryAnimation) {
                                                                                                return PhotoView(
                                                                                                  verifiedPosts[index1].imageSent,
                                                                                                  verifiedPosts[index1].imageSent,
                                                                                                );
                                                                                              },
                                                                                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                                return FadeTransition(
                                                                                                  opacity: animation,
                                                                                                  child: child,
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 170,
                                                                                          width: 170,
                                                                                          child: Card(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(3.0),
                                                                                              child: Image.network(
                                                                                                verifiedPosts[index1].imageSent,
                                                                                                fit: BoxFit.cover,
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
                                                                              width: 50,
                                                                            ),
                                                                            Expanded(
                                                                                child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  verifiedPosts[index1].message,
                                                                                  style: TextStyle(color: Colors.white),
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                                Consumer<DataProvider>(
                                                                                    // selector: (_,
                                                                                    //         provider) =>
                                                                                    //     provider
                                                                                    //         .selected,
                                                                                    builder: (context, selected, child) {
                                                                                  return Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    Icons.mode_comment_outlined,
                                                                                                    color: Colors.white,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    Navigator.push(
                                                                                                        context,
                                                                                                        PageRouteBuilder(
                                                                                                          pageBuilder: (context, animation, secondaryAnimation) {
                                                                                                            return Comment(verifiedPosts[index1]);
                                                                                                          },
                                                                                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                                            return FadeTransition(
                                                                                                              opacity: animation,
                                                                                                              child: child,
                                                                                                            );
                                                                                                          },
                                                                                                        ));
                                                                                                  },
                                                                                                ),
                                                                                                Text(verifiedPosts[index1].comment, style: TextStyle(color: Colors.white)),
                                                                                              ],
                                                                                            ),

                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FeatherIcons.thumbsUp,
                                                                                                    color: Colors.white,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    FirebaseApi.thumbUpPost(number: int.parse(verifiedPosts[index1].thumbup) + 1, id: verifiedPosts[index1].id);
                                                                                                  },
                                                                                                ),
                                                                                                Text(verifiedPosts[index1].thumbup, style: TextStyle(color: Colors.white)),
                                                                                              ],
                                                                                            ),

                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    FeatherIcons.thumbsDown,
                                                                                                    color: Colors.white,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    FirebaseApi.thumbDownPost(number: int.parse(verifiedPosts[index1].thumbdown) + 1, id: verifiedPosts[index1].id);
                                                                                                  },
                                                                                                ),
                                                                                                Text(verifiedPosts[index1].thumbdown, style: TextStyle(color: Colors.white)),
                                                                                              ],
                                                                                            ),

                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  icon: Icon(
                                                                                                    Icons.copy,
                                                                                                    color: Colors.white,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                  onPressed: () {
                                                                                                    FlutterClipboard.copy(verifiedPosts[index1].message).then((value) => scafoldKey.currentState.showSnackBar(SnackBar(content: Text('copied'))));
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),

                                                                                            // Icon(
                                                                                            //   verifiedPosts[index1].status == 'Bear'
                                                                                            //       ? FeatherIcons.eye
                                                                                            //       : verifiedPosts[index1].status == 'Bull'
                                                                                            //           ? FeatherIcons.eyeOff
                                                                                            //           : Icons.sentiment_neutral,
                                                                                            //   color: Colors.white,
                                                                                            //   size: 18,
                                                                                            // ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsets.only(bottom: verifiedPosts[index1].status == 'Bull' || verifiedPosts[index1].status == 'Bear' ? 8.0 : 0),
                                                                                              child: Icon(
                                                                                                verifiedPosts[index1].status == 'Bear'
                                                                                                    ? MyFlutterApp.bear
                                                                                                    : verifiedPosts[index1].status == 'Bull'
                                                                                                        ? MyFlutterApp.bull
                                                                                                        : Icons.sentiment_neutral,
                                                                                                color: verifiedPosts[index1].status == 'Bear'
                                                                                                    ? Colors.red
                                                                                                    : verifiedPosts[index1].status == 'Bull'
                                                                                                        ? Colors.green
                                                                                                        : Colors.white,
                                                                                                size: 24,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      // subComment(data: verifiedPosts[index1], scaffoldkey: scafoldKey,)
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
                                                      child:
                                                          CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                      }
                    } else {
                      return Center(child: Padding(
                        padding:EdgeInsets.only(top:MediaQuery.of(context).size.height/2.5),
                        child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditNameModal(context, id, name) {
    //final provider = Provider.of<EmailSignInProvider>(context, listen: false);
//    var network = Provider.of<WebServices>(context, listen: false);
//    var data = Provider.of<Utils>(context, listen: false);
    final _firstnameController = TextEditingController();
    final formKey1 = GlobalKey<FormState>();

    _firstnameController.text = name;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Form(
              key: formKey1,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12, top: 8),
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 12, right: 12, top: 5),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          // border: isAppEmpty ? Border.all(color: Colors.red) : null,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFF1F1FD),
                                blurRadius: 15.0,
                                offset: Offset(0.3, 4.0))
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              FeatherIcons.user,
                              color: Color(0xFF555555),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _firstnameController,
//                                inputFormatters: [
//                                  CreditCardExpirationDateFormatter()
//                                ],
//                            onChanged: (value){
//                              provider.setMyEmail(value);
//                            },
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Name cannot be blank';
                                }
                                // provider.setNewPin(v);
                                return null;
                              },
                              style: TextStyle(
                                  fontFamily: 'Firesans',
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),
                              //controller: expiryDate,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(
                                    fontFamily: 'Firesans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                focusColor: Color(0xFF2B1137),
                                fillColor: Color(0xFF2B1137),
                                hoverColor: Color(0xFF2B1137),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 40,
                        onPressed: () {
                          if (formKey1.currentState.validate()) {
                            FirebaseApi.updateProfile(
                              id,
                              _firstnameController.text,
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          }
                        },
                        color: Color(0xFF372C6A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 8, left: 8, right: 8),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Color(0xFF372C6A), width: 1.5)),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 40,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Color(0xFF372C6A),
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
