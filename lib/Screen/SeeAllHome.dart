

import 'package:fin_bul/Screen/Detail2.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:fin_bul/Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class SeeAllHome extends StatefulWidget {
  const SeeAllHome({Key key}) : super(key: key);

  @override
  _SeeAllHomeState createState() => _SeeAllHomeState();
}

class _SeeAllHomeState extends State<SeeAllHome> {

  List data2;

  final scafoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    WebServices network = Provider.of<WebServices>(context, listen: false);

    network.getStocks().then((value) {
      setState(() {
        data2 = value;
      });
    });

    super.initState();
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
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        'Todays Market',
                        style: TextStyle(
                          color: Color(0xFF705FBB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return SeeAllHome();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child){
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'see all',
                          style: TextStyle(
                              color: Color(0xFFFEB904),
                              fontWeight: FontWeight.bold),
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Indicator',
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
                Builder(
                    builder: (context) {
                      return data2 != null
                          ? ListView.builder(
                        itemCount: data2.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return Details2(data: data2[index]);
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data2[index].symbol??'',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      data2[index].close??'',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),

                                    Text(
                                      '${data2[index].percent_change??''}%',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                          color: data2[index].change.toString().contains('-')? Colors.red
                                              .withOpacity(0.2):data2[index].change==null?null:Color(0xFF26D375)
                                              .withOpacity(0.2),
                                          borderRadius:
                                          BorderRadius.circular(2)),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(2.0),
                                        child: Text('${data2[index].change??''}',
                                            style: TextStyle(
                                              color: data2[index].change.toString().contains('-')?Colors.red: data2[index].change==null?null:Color(0xFF26D375),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                          : data2 == null
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
                          )):Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          color: Color(0xFFBBBBBB),
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'No Stocks Available',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
