import 'dart:io';
import 'dart:ui';

import 'package:finbul/Screen/MyChats.dart';
import 'package:finbul/Screen/Ranking.dart';
import 'package:finbul/Screen/SearchPage.dart';
import 'package:finbul/Screen/WatchList.dart';
import 'package:finbul/Screen/chat.dart';
import 'package:finbul/Screen/feed.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Widgets/Drawer.dart';
import 'package:finbul/Widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'Home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final scafoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      drawer: Draw(),
      key: scafoldKey,
      backgroundColor: Color(0xFF372C6A),
      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (ctx) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: AlertDialog(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    content: Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Oops!!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF372C6A),
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Center(
                                  child: Text(
                                    'DO YOU WANT TO EXIT THIS APP?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF372C6A)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        return exit(0);
                                      },
                                      color: Color(0xFF372C6A),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(26),
                                  elevation: 2,
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF372C6A)),
                                        borderRadius:
                                            BorderRadius.circular(26)),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      color: Color(0xFF372C6A),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 190.0, minHeight: 53.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45.0, left: 2, right: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Image.asset(
                      'assets/LogoYellow.png',
                      width: 150,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.segment,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        scafoldKey.currentState.openDrawer();
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Hero(
                  tag: 'searchButton',
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return SearchPage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
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
                              enabled: false,
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
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF2A205D),
                          width: 2.0,
                        ),
                      ),
                    ),
                  )),
                  TabBar(

                    controller: _tabController,
                    unselectedLabelColor: Color(0xFF705FBB),
                    labelColor:  Color(0xFFFEB904),
                    indicatorColor: Color(0xFFFEB904),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: 'Home',
                      ),
                      Tab(
                        text: 'Watchlist',
                      ),
                      Tab(
                        text: 'Feed',
                      ),
                      Tab(
                        text: 'Ranking',
                      ),
                      Tab(
                        text: 'Chats',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Home(),
                  WatchList(),
                  Feed(),
                  Ranking(),
                  ListenIncoming()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
