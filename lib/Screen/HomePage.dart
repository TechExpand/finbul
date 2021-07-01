import 'package:fin_bul/Screen/MyChats.dart';
import 'package:fin_bul/Screen/Ranking.dart';
import 'package:fin_bul/Screen/SearchPage.dart';
import 'package:fin_bul/Screen/WatchList.dart';
import 'package:fin_bul/Screen/chat.dart';
import 'package:fin_bul/Screen/feed.dart';
import 'package:fin_bul/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 2, right: 20),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Image.asset('assets/LogoYellow.png', width: 150,),
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
                        pageBuilder: (context, animation, secondaryAnimation) {
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
    );
  }
}
