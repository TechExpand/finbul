import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_bul/Model/WatchList.dart';
import 'package:fin_bul/Screen/Detail2.dart';
import 'package:fin_bul/Screen/SearchPage.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:fin_bul/Service/firebase.dart';
import 'package:fin_bul/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class WatchList extends StatefulWidget {
  const WatchList({Key key}) : super(key: key);

  @override
  WatchListState createState() => WatchListState();
}

class WatchListState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context, listen: false);
    DataProvider provide = Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xFF372C6A),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color:  Color(0xFFFEB904), width: 2),
        ),
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) {
                    return SearchPage();
                  },
                  transitionsBuilder: (context, animation,
                      secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Text(
                  'Most Watched',
                  style: TextStyle(
                    color: Color(0xFF705FBB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 130,
                height: 100,
                child: FutureBuilder(
                    future: network.getMostWatchStocks(),
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
                                height: 4,
                              ),
                              Text('Loading Stocks',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ))
                        : snapshot.hasData && !snapshot.data.isEmpty
                        ?  ListView.builder(
                       itemCount: snapshot.data.length ,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context , index){
                        return  InkWell(
                          onTap: (){
                            Navigator.push(context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                  return Details2(data: snapshot.data[index]);
                                }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            width: 150,
                            height: 100,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: Image.asset( snapshot.data[index].change
                                          .toString().contains('-')?'assets/red.png':'assets/green.png', width: 700,),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data[index].symbol}',
                                              style: TextStyle(
                                                  color: Color(0xFF372C6A),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            snapshot.data[index].change
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
                                        ),
                                        SizedBox(height: 37),
                                        Row(
                                          children: [
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  '${snapshot.data[index].close}',
                                                  style: TextStyle(
                                                      color: Color(0xFF372C6A),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold),
                                                )),
                                            Spacer(),

                                            Text(
                                              '${snapshot.data[index].percent_change}%',
                                              style: TextStyle(
                                                  color: snapshot.data[index].change
                                                      .toString().contains('-')
                                                      ? Colors.red
                                                      : Color(0xFF26D375),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
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
                    'No Stock Available',
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
                    left: 20, right: 20, top: 30, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      'My Watchlist',
                      style: TextStyle(
                        color: Color(0xFF705FBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '',
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                color: Color(0xFF1E1450),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stocks',
                        style: TextStyle(
                          color: Color(0xFF705FBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Icon(
                        FeatherIcons.dollarSign,
                        color: Color(0xFF705FBB),
                        size: 18,
                      ),

                      Icon(
                        Icons.mode_comment_outlined,
                        color: Color(0xFF705FBB),
                        size: 18,
                      ),

                      Row(
                        children: [
                          Text(
                            '↑',
                            style: TextStyle(
                                color: Color(0xFF705FBB),
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                          Text(
                            '↓',
                            style: TextStyle(
                                color: Color(0xFF705FBB),
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              StatefulBuilder(
                builder:(context, setState)=> StreamBuilder(
                    stream: FirebaseApi.watchListStream(provide.firebaseUserId),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData) {
        List<WatchListModel> watchlist;
        watchlist = snapshot.data.docs
            .map((doc) => WatchListModel.fromMap(doc.data(), doc.id))
            .toList();

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
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
                final verifiedwatchlist = watchlist;
                if (verifiedwatchlist.isEmpty) {
                  return Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Center(
                          child: Text(
                            'No WatchList Available',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          )));
                } else {
                  return FutureBuilder(
                      future: network.getWatchListStocks(verifiedwatchlist),
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
                                  Text('Loading WatchList',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ))
                            : snapshot.hasData && !snapshot.data.isEmpty
                            ? ListView.builder(
                          itemCount: snapshot.data.length,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              actions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: FeatherIcons.delete,
                                  onTap: () {
                                    FirebaseApi.deleteWatchList(verifiedwatchlist[index].id).then((value){
                                      setState(() {
                                        print('done');
                                      });
                                    });
                                  }
                                ),

                              ],
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                  PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation){
                                        return Details2(data: snapshot.data[index]);
                                      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  height: 50,
                                  color: index.isEven
                                      ? Color(0xFF403477)
                                      : Color(0xFF372C6A),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data[index].symbol,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        Text(
                                          snapshot.data[index].close.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),

                                        Text(
                                          '${snapshot.data[index].percent_change
                                              .toString()}%',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),

                                        Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data[index].change
                                                  .toString().contains('-') ? Colors
                                                  .red
                                                  .withOpacity(0.2) : Color(
                                                  0xFF26D375)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                              BorderRadius.circular(2)),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(2.0),
                                            child: Text(
                                                '${snapshot.data[index].change
                                                    .toString()}',
                                                style: TextStyle(
                                                  color: snapshot.data[index].change
                                                      .toString().contains('-')
                                                      ? Colors.red
                                                      : Color(0xFF26D375),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                            : snapshot.data.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            color: Color(0xFFBBBBBB),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              'No WatchList Available',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                            : Container();
                      });
                }
            }
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
