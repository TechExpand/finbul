import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_bul/Model/Profile.dart';
import 'package:fin_bul/Model/WatchList.dart';
import 'package:fin_bul/Model/post.dart';
import 'package:fin_bul/Screen/Ranking.dart';
import 'package:fin_bul/Screen/WatchList.dart';
import 'package:fin_bul/Widgets/Drawer.dart';
import 'package:fin_bul/Widgets/icons.dart';
import 'package:fin_bul/Widgets/photoView.dart';
import 'package:fin_bul/Screen/chat.dart';
import 'package:fin_bul/Screen/comment.dart';
import 'package:fin_bul/Screen/feed.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:fin_bul/Service/firebase.dart';
import 'package:fin_bul/Utils/Provider.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'Home.dart';
import 'TimeSeries.dart';

class SearchDetails extends StatefulWidget {
  var data;

  SearchDetails({this.data});

  @override
  SearchDetailsState createState() => SearchDetailsState();
}

class SearchDetailsState extends State<SearchDetails>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _selected = false;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }
  final scafoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider provide = Provider.of<DataProvider>(context, listen: false);
    WebServices network = Provider.of<WebServices>(context, listen: false);

    List date = [
      '30min',
      '1hour',
      '4hour',
      'Day',
      'Week',
      'Month',
    ];

    SelectedValue(value) {
      if (value == '30min') {
        return '30min';
      } else if (value == '1hour') {
        return '1h';
      } else if (value == '4hour') {
        return '4h';
      } else if (value == 'Day') {
        return '1day';
      } else if (value == 'Week') {
        return '1week';
      } else if (value == 'Month') {
        return '1month';
      }
    }

    int selectedIndex = 0;
    String selectedValue = '30min';

    return Scaffold(
      drawer: Draw(),
      key: scafoldKey,
      backgroundColor: Color(0xFF372C6A),
      body: ListView(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: ScrollPhysics(),
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
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: FutureBuilder(
                future: network.getStockSearchDetail(widget.data.symbol),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Loading Stocks',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ))
                      : snapshot.hasData
                          ? ListView(
                              padding: EdgeInsets.all(0),
                              children: [
                                Container(
                                  height: 50,
                                  color: Color(0xFF403477),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  margin: const EdgeInsets.only(top: 40.0),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 4.0),
                                            child: Icon(
                                              Icons.keyboard_backspace_rounded,
                                              color: Color(0xFFFEB904),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          child: Text(
                                            snapshot.data['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          child: Text(
                                            snapshot.data['symbol'],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        StreamBuilder(
                                            stream: FirebaseApi.watchListStream(provide.firebaseUserId),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshotstream) {
                                              if (snapshotstream.hasData) {
                                                List<WatchListModel> watchlist;
                                                watchlist = snapshotstream.data.docs
                                                    .map((doc) => WatchListModel.fromMap(
                                                        doc.data(), doc.id))
                                                    .toList();

                                                switch (
                                                snapshotstream.connectionState) {
                                                  case ConnectionState.waiting:
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  default:
                                                    if (snapshotstream.hasError) {
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
                                                      final verifiedwatchlist =
                                                          watchlist;
                                                      if (verifiedwatchlist
                                                          .isEmpty) {
                                                        return Container(
                                                          child: FlatButton(
                                                            onPressed: () {
                                                              print('hhhhhhh');
                                                             FirebaseApi.uploadWatchList(id: provide.firebaseUserId, symbol:  snapshot.data['symbol']);
                                                            },
                                                            color: Color(
                                                                0xFFFEB904),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    26)),
                                                            padding:
                                                            EdgeInsets.all(
                                                                0.0),
                                                            child: Ink(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      26)),
                                                              child: Container(
                                                                height: 23,
                                                                constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                    135.0,
                                                                    minHeight:
                                                                    23.0),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                  "Add to Watchlist",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        var watch = [];
                                                        for(var value in verifiedwatchlist){
                                                          watch.add(value.symbol);
                                                        }
                                                        if(watch.contains(snapshot.data['symbol'])){
                                                        return Container(
                                                          child: FlatButton(
                                                              onPressed: null,
                                                            color: Color(
                                                                0xFFFEB904),
                                                            disabledColor: Color(
                                                                0xFFFEB904),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            26)),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0.0),
                                                            child: Ink(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              26)),
                                                              child: Container(
                                                                height: 23,
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxWidth:
                                                                            135.0,
                                                                        minHeight:
                                                                            23.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Added to Watchlist",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );}else{
                                                          return Container(
                                                            child: FlatButton(
                                                              onPressed: () {
                                                                print('gggggggggggg');
                                                                FirebaseApi.uploadWatchList(id: provide.firebaseUserId, symbol:  snapshot.data['symbol']);
                                                              },
                                                              color: Color(
                                                                  0xFFFEB904),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      26)),
                                                              padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        26)),
                                                                child: Container(
                                                                  height: 23,
                                                                  constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                      135.0,
                                                                      minHeight:
                                                                      23.0),
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  child: Text(
                                                                    "Add to Watchlist",
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    }
                                                }
                                              } else {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'USD ${snapshot.data['close']}',
                                        style: TextStyle(
                                            color: Color(0xFFFEB904),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          '(△ ${snapshot.data['percent_change']}%)',
                                          style: TextStyle(
                                              color: snapshot.data['percent_change']
                                                  .toString().contains('-')
                                                  ? Colors.red
                                                  : Color(0xFF26D375),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // Icon(
                                      //   FeatherIcons.eye,
                                      //   color: Color(0xFF7B69CA),
                                      // )
                                    ],
                                  ),
                                ),
                                StatefulBuilder(builder: (context, setState) {
                                  return Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        height: 30,
                                        child: ListView.builder(
                                          itemCount: date.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                  selectedValue = date[index];
                                                });
                                                ItemDetailsPage(
                                                    symbol: widget.data.symbol
                                                        .toString(),
                                                    data: SelectedValue(
                                                        selectedValue));
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 8),
                                                height: 30,
                                                child: Center(
                                                    child: Text(
                                                  '${date[index]}',
                                                  style: TextStyle(
                                                      color: selectedIndex ==
                                                              index
                                                          ? Color(0xFF403477)
                                                          : Colors.white),
                                                )),
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: selectedIndex == index
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Center(
                                          child: Container(
                                              child: ItemDetailsPage(
                                                  symbol: widget.data.symbol
                                                      .toString(),
                                                  data: SelectedValue(
                                                      selectedValue)))),
                                    ],
                                  );
                                }),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 0),
                                  child: Text(
                                    'Sentiment',
                                    style: TextStyle(
                                      color: Color(0xFF705FBB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                StreamBuilder(
                                    stream: FirebaseApi.bearbulltotalStream(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                                      if (snapshots.hasData) {
                                        List<Post> posts1;
                                        posts1 = snapshots.data.docs
                                            .map((doc) => Post.fromMap(doc.data(), doc.id))
                                            .toList();

                                        switch (snapshots.connectionState) {
                                          case ConnectionState.waiting:
                                            return Center(child: CircularProgressIndicator());
                                          default:
                                            if (snapshots.hasError) {
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
                                              final verifiedPostsComment = posts1;
                                              if (verifiedPostsComment.isEmpty) {
                                                return Container(
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 20, top: 15),
                                                    child: Center(
                                                        child: Text(
                                                          'No Data',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold),
                                                        )));
                                              } else {
                                                var bearish = [];
                                                var bullish = [];
                                                for(var value in verifiedPostsComment){
                                                  if(value.status == 'Bear'){
                                                    bearish.add(value.status);
                                                  }else if(value.status == 'Bull'){
                                                    bullish.add(value.status);
                                                  }
                                                }

                                                return ListView(
                                                    padding: EdgeInsets.all(0),
                                                    physics: ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        color: Color(0xFF403477),
                                                        padding: EdgeInsets.only(left: 20, right: 20),
                                                        margin: const EdgeInsets.only(top: 20.0),
                                                        child: Center(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Finbul community\n is mostly:',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              Spacer(),
                                                              ((bearish.length / verifiedPostsComment.length) *
                                                                  100)
                                                                  .ceil() <=
                                                                  ((bullish.length / verifiedPostsComment.length) *
                                                                      100)
                                                                      .ceil()
                                                                  ? Icon(
                                                                MyFlutterApp
                                                                    .bear,
                                                                color: Colors.red,
                                                                size: 40,
                                                              )
                                                                  : Icon(
                                                                MyFlutterApp
                                                                    .bull,
                                                                color:Color(
                                                                    0xFF26D375),
                                                                size: 40,
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets.only(left: 15.0,top: 20),
                                                                child: Text(
                                                                  "${((bearish.length/verifiedPostsComment.length)*100).ceil()<=((bullish.length/verifiedPostsComment.length)*100).ceil()?'Bearish':'Bullish'}",
                                                                  style: TextStyle(
                                                                      color: ((bearish.length/verifiedPostsComment.length)*100).ceil()<=((bullish.length/verifiedPostsComment.length)*100).ceil()?Colors.red:Color(0xFF26D375),
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 20, right: 20, top: 20, bottom: 20),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Sentiment Score',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                '',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                              ),

                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.green.withOpacity(0.2),
                                                                    borderRadius: BorderRadius.circular(2)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 2.0, bottom: 2, left: 6, right: 6),
                                                                  child: Text("${((bearish.length/verifiedPostsComment.length)*100).ceil()<=((bullish.length/verifiedPostsComment.length)*100).ceil()?'-${((bearish.length/verifiedPostsComment.length)*100).ceil()}%':'+${((bullish.length/verifiedPostsComment.length)*100).ceil()}%'}",
                                                                      style: TextStyle(
                                                                        color: ((bearish.length/verifiedPostsComment.length)*100).ceil()<=((bullish.length/verifiedPostsComment.length)*100).ceil()?Colors.red:Color(0xFF26D375),
                                                                        fontWeight: FontWeight.bold,
                                                                      )),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                      Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 20, right: 20, top: 20, bottom: 20),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Average Volume',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text(
                                                                '${snapshot.data['volume']}',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 50,
                                                              ),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.green.withOpacity(0.2),
                                                                    borderRadius: BorderRadius.circular(2)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 2.0, bottom: 2, left: 6, right: 6),
                                                                  child: Text('${snapshot.data['average_volume']}',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF26D375),
                                                                        fontWeight: FontWeight.bold,
                                                                      )),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ]);
                                              }
                                            }
                                        }
                                      } else {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    }),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
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
                                        isScrollable: false,
                                        tabs: [
                                          Tab(
                                            text: 'Feed',
                                          ),
                                          Tab(
                                            text: 'News',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 400,
                                  child: TabBarView(
                                    physics: ScrollPhysics(),
                                    controller: _tabController,
                                    children: [
                                      StreamBuilder(
                                        stream: FirebaseApi.profileStream(
                                            provide.firebaseUserId),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            List<Profile> profiles;
                                            profiles = snapshot.data.docs
                                                .map((doc) => Profile.fromMap(
                                                    doc.data(), doc.id))
                                                .toList();

                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              default:
                                                if (snapshot.hasError) {
                                                  return Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 15),
                                                      child: Center(
                                                          child: Text(
                                                        'Something Went Wrong Try later',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )));
                                                } else {
                                                  final verifiedProfile =
                                                      profiles;
                                                  if (verifiedProfile.isEmpty) {
                                                    return Container();
                                                  } else {
                                                    provide.setFirstName(
                                                        verifiedProfile[0]
                                                            .name);
                                                    return StreamBuilder(
                                                      stream: FirebaseApi
                                                          .postStream(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        List<Post> posts;
                                                        if (snapshot.hasData) {
                                                          posts = snapshot
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
                                                                    padding: EdgeInsets.only(
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
                                                                              FontWeight.bold),
                                                                    )));
                                                              } else {
                                                                final verifiedPosts =
                                                                    posts;
                                                                if (verifiedPosts
                                                                    .isEmpty) {
                                                                  return Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20,
                                                                          top:
                                                                              15),
                                                                      child: Center(
                                                                          child: Text(
                                                                              'No Post Found',
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
                                                                } else
                                                                  return Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child: ListView
                                                                          .builder(
                                                                        padding:
                                                                            EdgeInsets.only(top: 15),
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            ScrollPhysics(),
                                                                        itemCount:
                                                                            verifiedPosts.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index1) {
                                                                          return Container(
                                                                            padding:
                                                                                EdgeInsets.only(top: 15, bottom: 5),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
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
                                                                                        FirebaseApi.addUserChat(
                                                                                          urlAvatar2: verifiedProfile[0].picture,
                                                                                          name2: verifiedProfile[0].name,
                                                                                          idArtisan: provide.firebaseUserId,
                                                                                          artisanMobile: verifiedProfile[0].number,
                                                                                          userMobile: verifiedPosts[index1].phone,
                                                                                          idUser: verifiedPosts[index1].userid,
                                                                                          urlAvatar: verifiedPosts[index1].picture,
                                                                                          name: verifiedPosts[index1].name,
                                                                                        );
                                                                                        Navigator.push(context,  PageRouteBuilder(
                                                                                          pageBuilder: (context, animation, secondaryAnimation) {
                                                                                          return ChatPage(
                                                                                            user: verifiedPosts[index1],
                                                                                          );
                                                                                        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                                                                                      },
                                                                                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                                                                        const PopupMenuItem(
                                                                                          value: 'Message',
                                                                                          child: Text('Message'),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                verifiedPosts[index1].imageSent == null || verifiedPosts[index1].imageSent.toString().isEmpty
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
                                                                                      width: 60,
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
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 8.0),
                                                                                          child: Row(
                                                                                            children: [
                                                                                            Row(
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                icon: Icon( Icons.mode_comment_outlined,
                                                                                                      color: Colors.white,
                                                                                                      size: 18,
                                                                                                ), onPressed: (){
                                                                                                      Navigator.push(context,  PageRouteBuilder(
                                                                                                        pageBuilder: (context, animation, secondaryAnimation){
                                                                                                          return Comment(verifiedPosts[index1]);
                                                                                                        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                                                                        return FadeTransition(
                                                                                                          opacity: animation,
                                                                                                          child: child,
                                                                                                        );
                                                                                                      },));
                                                                                                    },),
                                                                                                    Text(verifiedPosts[index1].comment, style: TextStyle(color: Colors.white)),
                                                                                                  ],
                                                                                                ),

                                                                                              SizedBox(
                                                                                                width: 20,
                                                                                              ),

                                                                                             Row(
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                     icon:Icon( FeatherIcons.thumbsUp,
                                                                                                      color: Colors.white,
                                                                                                      size: 18,
                                                                                                    ),
                                                                                                    onPressed: (){
                                                                                                      FirebaseApi.thumbUpPost(number: int.parse(verifiedPosts[index1].thumbup) + 1, id: verifiedPosts[index1].id);
                                                                                                    },),
                                                                                                    Text(verifiedPosts[index1].thumbup, style: TextStyle(color: Colors.white)),
                                                                                                  ],
                                                                                                ),

                                                                                              SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                               Row(
                                                                                                  children: [
                                                                                                    IconButton(
                                                                                                    icon:Icon(  FeatherIcons.thumbsDown,
                                                                                                      color: Colors.white,
                                                                                                      size: 18,
                                                                                                    ), onPressed: (){
                                                                                                      FirebaseApi.thumbDownPost(number: int.parse(verifiedPosts[index1].thumbdown) + 1, id: verifiedPosts[index1].id);
                                                                                                    },),
                                                                                                    Text(verifiedPosts[index1].thumbdown, style: TextStyle(color: Colors.white)),
                                                                                                  ],
                                                                                                ),
                                                                                              SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  IconButton(
                                                                                                    icon:Icon( Icons
                                                                                                        .copy,
                                                                                                      color: Colors
                                                                                                          .white,
                                                                                                      size: 18,
                                                                                                    ),
                                                                                                    onPressed: (){
                                                                                                      FlutterClipboard.copy(verifiedPosts[index1].message.toString()).then(( value ) =>  scafoldKey.currentState.showSnackBar(SnackBar(content:Text('copied'))));
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),

                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),

                                                                                              Padding(
                                                                                                padding:  EdgeInsets.only(bottom:    verifiedPosts[index1].status =='Bull' ||   verifiedPosts[index1].status =='Bear'? 8.0:0),
                                                                                                child: Icon(
                                                                                                  verifiedPosts[index1].status =='Bear'? MyFlutterApp.bear
                                                                                                      :    verifiedPosts[index1].status =='Bull'? MyFlutterApp.bull
                                                                                                      :Icons
                                                                                                      .sentiment_neutral,
                                                                                                  color:   verifiedPosts[index1].status =='Bear'? Colors
                                                                                                      .red
                                                                                                      :    verifiedPosts[index1].status =='Bull'? Colors
                                                                                                      .green
                                                                                                      :Colors
                                                                                                      .white,
                                                                                                  size: 25,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // Consumer<DataProvider>(
                                                                                            
                                                                                        //     builder: (context, selected, child) {
                                                                                        //   return
                                                                                        //       subComment(data: verifiedPosts[index1]);

                                                                                        // }),
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
                                                                  CircularProgressIndicator());
                                                        }
                                                      },
                                                    );
                                                  }
                                                }
                                            }
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                      FutureBuilder(
                                          future: network.getStockNews(
                                              snapshot.data['symbol']),
                                          builder: (context, snapshot) {
                                            return !snapshot.hasData
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text('Loading News',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                    ))
                                                : snapshot.hasData &&
                                                        !snapshot.data.isEmpty
                                                    ? ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: snapshot
                                                            .data.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    top: 10),
                                                            color: index.isEven
                                                                ? Color(
                                                                    0xFF403477)
                                                                : Color(
                                                                    0xFF372C6A),
                                                            child: ListTile(
                                                              leading:
                                                                  Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Image
                                                                      .network(
                                                                    '${snapshot.data[index]['image']}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                height: 200,
                                                                width: 80,
                                                              ),
                                                              title: Text(
                                                                  '${snapshot.data[index]['title']}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              subtitle: Text(
                                                                  '10 Apr 21 | 09:33',
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFFEB904))),
                                                            ),
                                                          );
                                                        })
                                                    : snapshot.data.isEmpty
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(18.0),
                                                            child: Center(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                child: Text(
                                                                  'No News Available',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container();
                                          })
                                    ],
                                  ),
                                )
                              ],
                            )
                          : snapshot.data.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    color: Color(0xFFBBBBBB),
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      'No  News Available',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : Container();
                }),
          )
        ],
      ),
    );
  }
}
