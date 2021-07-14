import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finbul/Model/post.dart';
import 'package:finbul/Screen/Details.dart';
import 'package:finbul/Service/Network.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key key}) : super(key: key);

  @override
  RankingState createState() => RankingState();
}

class RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xFF372C6A),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 0, bottom: 2),
                child: Row(
                  children: [
                    Text(
                      'Top Losers',
                      style: TextStyle(
                        color: Color(0xFF705FBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '',
                      style: TextStyle(
                          color: Color(0xFFFEB904),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 130,
                height: 120,
                child: FutureBuilder(
                    future: network.getToplosers(),
                    builder: (context, snapshot) {
                      return  !snapshot.hasData
                          ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
),
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
                          : snapshot.hasData && !snapshot.data.isEmpty
                          ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                    return Details(data: snapshot.data[index]);
                                  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 130,
                              height: 120,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                  Center(
                                    child:  Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: Image.asset( snapshot.data[index].changes
                                          .toString().contains('-')?'assets/bearish.png':'assets/bullish.png', width: 700,),
                                    ),
                                  ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index].symbol,
                                                style: TextStyle(
                                                    color: Color(0xFF372C6A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.mode_comment_outlined,
                                                color: Colors.black12,
                                                size: 18,
                                              ),
                                              Text(
                                                snapshot.data[index].changesPercentage.toString().replaceAll('(', '').replaceAll(')', ''),
                                                style: TextStyle(
                                                    color: snapshot.data[index].changesPercentage.toString().contains('+')?Color(0xFF26D375):Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                         Spacer(),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index].changes.toString(),
                                                style: TextStyle(
                                                    color: snapshot.data[index].changes.toString().contains('-')?Colors.red:Color(0xFF26D375),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Row(
                                            children: [
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    width: 80,
                                                    child: Text(
                                                      snapshot.data[index].companyName.toString(),
                                                      style: TextStyle(
                                                          color: Color(0xFF372C6A),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                              Spacer(),
                                              snapshot.data[index].changes
                                                  .toString().contains('-')?Text(
                                                '↓',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ):Text(
                                                '↑',
                                                style: TextStyle(
                                                    color: Color(0xFF26D375),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ): snapshot.data.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          color: Color(0xFFBBBBBB),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'No Trending Stocks Available',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                          : Container();
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 15, bottom: 2),
                child: Row(
                  children: [
                    Text(
                      'Top Gainers',
                      style: TextStyle(
                        color: Color(0xFF705FBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '',
                      style: TextStyle(
                          color: Color(0xFFFEB904),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                width: 130,
                height: 120,
                child: FutureBuilder(
                    future: network.getTopGainers(),
                    builder: (context, snapshot) {
                      return  !snapshot.hasData
                          ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
),
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
                          : snapshot.hasData && !snapshot.data.isEmpty
                          ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                    return Details(data: snapshot.data[index]);
                                  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 130,
                              height: 120,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child:  Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Image.asset( snapshot.data[index].changes
                                              .toString().contains('-')?'assets/bearish.png':'assets/bullish.png', width: 700,),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index].symbol,
                                                style: TextStyle(
                                                    color: Color(0xFF372C6A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.mode_comment_outlined,
                                                color: Colors.black12,
                                                size: 18,
                                              ),
                                              Text(
                                                snapshot.data[index].changesPercentage.toString().replaceAll('(', '').replaceAll(')', ''),
                                                style: TextStyle(
                                                    color: snapshot.data[index].changesPercentage.toString().contains('+')?Color(0xFF26D375):Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data[index].changes.toString(),
                                                style: TextStyle(
                                                    color: snapshot.data[index].changes.toString().contains('-')?Colors.red:Color(0xFF26D375),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Row(
                                            children: [
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    width: 80,
                                                    child: Text(
                                                      snapshot.data[index].companyName.toString(),
                                                      style: TextStyle(
                                                          color: Color(0xFF372C6A),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                              Spacer(),
                                              snapshot.data[index].changes
                                                  .toString().contains('-')?Text(
                                                '↓',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ):Text(
                                                '↑',
                                                style: TextStyle(
                                                    color: Color(0xFF26D375),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ): snapshot.data.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          color: Color(0xFFBBBBBB),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'No Trending Stocks Available',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                          : Container();
                    }
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      'Finbul Stock Sentiment',
                      style: TextStyle(
                        color: Color(0xFF705FBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      ' ',
                      style: TextStyle(
                          color: Color(0xFFFEB904),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                color: Color(0xFF1E1450),
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'Community',
                        style: TextStyle(
                          color: Color(0xFF705FBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '↑↓',
                        style: TextStyle(
                            color: Color(0xFF705FBB),
                            fontWeight: FontWeight.bold,
                            fontSize: 23),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseApi.bearbulltotalStream(),
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
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: ListTile(
                                        trailing: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text("+${((bearish.length/verifiedPostsComment.length)*100).ceil()}%",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        title: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0, right: 4),
                                            child: Text(
                                              'BULLISH',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            '@finbulcom',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ]),
                                        leading:  Container(
                                        margin:EdgeInsets.only(bottom:15),
                                          child:Icon(
                                          MyFlutterApp
                                              .bull,
                                          color:Color(
                                              0xFF26D375),
                                          size: 40,
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: ListTile(
                                        trailing: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text("-${((bullish.length/verifiedPostsComment.length)*100).ceil()}%",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        title: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0, right: 4),
                                            child: Text(
                                              'BEARISH',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            '@finbulcom',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ]),
                                        leading: Container(
                                          margin:EdgeInsets.only(bottom:15),
                                          child: Icon(
                                            MyFlutterApp
                                                .bear,
                                            color:Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                            }
                          }
                      }
                    } else {
                      return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      'Community Ranking Table',
                      style: TextStyle(
                        color: Color(0xFF705FBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      ' ',
                      style: TextStyle(
                          color: Color(0xFFFEB904),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                color: Color(0xFF1E1450),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'Stocks',
                        style: TextStyle(
                          color: Color(0xFF705FBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        'Sentiment Scores',
                        style: TextStyle(
                          color: Color(0xFF705FBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.speed,
                        color: Color(0xFF705FBB),
                      )
                    ],
                  ),
                ),
              ),
              ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    color: Color(0xFF372C6A),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            'ACL',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            height: 10,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Color(0xFF26D375),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 10, right: 10),
                              child: Text('6.8',
                                  style: TextStyle(
                                    color: Color(0xFF26D375),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    color: Color(0xFF403477),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            'BTC',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            height: 10,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Color(0xFF26D375),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 10, right: 10),
                              child: Text('6.4',
                                  style: TextStyle(
                                    color: Color(0xFF26D375),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    color: Color(0xFF372C6A),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            'MTN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            height: 10,
                            width: 110,
                            decoration: BoxDecoration(
                                color: Color(0xFF26D375),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 10, right: 10),
                              child: Text('6.1',
                                  style: TextStyle(
                                    color: Color(0xFF26D375),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    color: Color(0xFF403477),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            'NTC',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 10, right: 10),
                              child: Text('4.5',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
