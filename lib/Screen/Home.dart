import 'package:finbul/Screen/Detail2.dart';
import 'package:finbul/Screen/Details.dart';
import 'package:finbul/Service/Network.dart';
import 'package:finbul/Screen/SeeAllHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List data;
  List data2;


  @override
  void initState(){
    WebServices network = Provider.of<WebServices>(context, listen: false);
  network.getTrendingStocks().then((value) {
    setState(() {
      data = value;
    });
  });

    network.getStocks().then((value) {
      setState(() {
        data2 = value;
      });
    });

    super.initState();
  }



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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Text(
                  'Trending in the Community',
                  style: TextStyle(
                    color: Color(0xFF705FBB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 130,
                height: 182,
                child: data != null
                        ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation){
                                  return Details(data: data[index]);
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
                            height: 182,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index].symbol,
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
                                          data[index].changesPercentage.toString().replaceAll('(', '').replaceAll(')', ''),
                                          style: TextStyle(
                                              color: data[index].changesPercentage.toString().contains('+')?Color(0xFF26D375):Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Center(
                                      child:  Container(
                                        margin: EdgeInsets.only(top: 0),
                                        child: Image.asset( data[index].changes
                                            .toString().contains('-')?'assets/red.png':'assets/green.png', height: 90,),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            data[index].changes.toString(),
                                          style: TextStyle(
                                              color: data[index].changes.toString().contains('-')?Colors.red:Color(0xFF26D375),
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
                                                data[index].companyName.toString(),
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
                                        data[index].changes
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
                              ),
                            ),
                          ),
                        );
                      },
                    ): data == null
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
                    )):Padding(
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
                )),


              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 30, bottom: 15),
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
                        Navigator.push(
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
                                itemCount: 10,
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
                                              data2[index].symbol.toString()??'',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                            Text(
                                              data2[index].close.toString()??'',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),

                                            Text(
                                              '${data2[index].percent_change.toString()??''}%',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),

                                            Container(
                                              decoration: BoxDecoration(
                                                  color: data2[index].change.toString().contains('-')? Colors.red
                                                      .withOpacity(0.2):data2[index].change.toString()==null?null:Color(0xFF26D375)
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text('${data2[index].change.toString()??''}',
                                                    style: TextStyle(
                                                      color: data2[index].change.toString().contains('-')?Colors.red: data2[index].change.toString()==null?null:Color(0xFF26D375),
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
      ),
    );
  }
}
