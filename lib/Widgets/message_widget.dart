// import 'package:fixme/Model/Message.dart';
// import 'package:fixme/Utils/Provider.dart';
// import 'package:fixme/Utils/utils.dart';
// import 'package:fixme/Widgets/photoView.dart';
// import 'package:fixme/Widgets/recordPlayer.dart';
import 'package:fin_bul/Model/Message.dart';
import 'package:fin_bul/Utils/Provider.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:fin_bul/Widgets/recordPlayer.dart';
import 'package:fin_bul/Widgets/photoView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment
                .start,
            children: <Widget>[
            if (!isMe)
        Padding(
        padding: const EdgeInsets.all(8.0), child:Text(message.username, style: TextStyle(color:Color( 0xFFFEB904)),)
    ),
    !isMe
    ?
    buildMessageReceiver(context):
    buildMessageSender(context)
    ,
    if(isMe)
    Padding(
    padding: const
    EdgeInsets.all(8.0),
    child: Text(message.username, style: TextStyle(color:Color( 0xFFFEB904)))
    ,
    )
    ,
    ]
    ,
    )
    ,
    );
  }


  Widget buildMessageReceiver(context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
//    var date = data
//        .formatTime(message.createdAt);
    var date =  data.compareDate(message.createdAt);
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        message.message.contains('https://') ||
            message.message.contains('http://')

            ? datas.categorizeUrl(message.message) == 'image'
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Hero(
            tag: message.message,
            child: GestureDetector(
              onTap: () {
                return Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PhotoView(
                        message.message,
                        message.message,
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child:Container(
                height: 170,
                width: 170,
                child: Card(
                  color:Color( 0xFFFEB904),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.network(
                      message.message,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            : datas.categorizeUrl(message.message) == 'audio'
            ? GestureDetector(
          onTap: () {
            return Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AudioApp(kUrl: message.message, tag: message.message);
                },
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                  tag: message.message,
                  child: Icon(Icons.play_circle_filled, size: 35,)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color( 0xFFFEB904),
                  inactiveTrackColor:Color( 0xFFFEB904),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFF5e5780),
                  overlayColor:Color( 0xFFFEB904),
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Color( 0xFFFEB904),
                  inactiveTickMarkColor:Color( 0xFFFEB904),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFF5e5780),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: 0,
                  onChanged: (double value) {

                  },
                  min: 0.0,
                  max: 10.0,
                ),
              ),
            ],
          ),

        )  :
        datas.categorizeUrl(message.message) == 'doc'
            ? InkWell(
               onTap: () {
                data.opeLink(message.message);
                          },
              child: Tab(
                text: 'Open this Document/Download',
                icon: Icon(FontAwesomeIcons.file , size: 40),
              )) : datas.categorizeUrl(message.message) == 'link'?
             Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.2,
          child: InkWell(
             onTap: () {
                data.opeLink(message.message);
                          },
                      child: Text(
              message.message,
              style: TextStyle(color: isMe ? Colors.blue : Colors.blue),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ) :Container(): Card(
          color: Color(0xFF403477),
          child: Container(
            color: Color(0xFF403477),
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.message,
                style: TextStyle(color: isMe ? Colors.white : Colors.white),
                textAlign: isMe ? TextAlign.start : TextAlign.end,
              ),
            ),
          ),
        ),

        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color:Color( 0xFFFEB904),
                  shape: BoxShape.circle
              ),
            ),
            // Text(message.username),
            Text(date, style:TextStyle(color:Color( 0xFFFEB904))),
          ],
        ),
      ],
    );
  }


  Widget buildMessageSender(context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
//    var date = data
//        .formatTime(message.createdAt);
    var date =  data.compareDate(message.createdAt);
    return Column(
      crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        message.message.contains('https://') ||
            message.message.contains('http://')

            ? datas.categorizeUrl(message.message) == 'image'
            ? Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Hero(
            tag: message.message,
            child: GestureDetector(
              onTap: () {
                return Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PhotoView(
                        message.message,
                        message.message,
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
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
                color:Color( 0xFFFEB904),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.network(
                      message.message,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            : datas.categorizeUrl(message.message) == 'audio'
            ? GestureDetector(
          onTap: () {
            return Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AudioApp(kUrl: message.message, tag: message.message);
                },
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Hero(
                  tag: message.message,
                  child: Icon(Icons.play_circle_filled, size: 35,)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color( 0xFFFEB904),
                  inactiveTrackColor:Color( 0xFFFEB904),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 5.0,
                  thumbShape:
                  RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Color(0xFF5e5780),
                  overlayColor:Color( 0xFFFEB904),
                  overlayShape:
                  RoundSliderOverlayShape(overlayRadius: 15.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Color( 0xFFFEB904),
                  inactiveTickMarkColor:Color( 0xFFFEB904),
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Color(0xFF5e5780),
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: 0,
                  onChanged: (double value) {

                  },
                  min: 0.0,
                  max: 10.0,
                ),
              ),
            ],
          ),

        ) :
        datas.categorizeUrl(message.message) == 'doc'
            ? InkWell(
               onTap: () {
                data.opeLink(message.message);
                          },
              child: Tab(
                text: 'Open this Document/Download',
                icon: Icon(FontAwesomeIcons.file , size: 40),
              )) : datas.categorizeUrl(message.message) == 'link'? Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.2,
          child: InkWell(
             onTap: () {
                data.opeLink(message.message);
                          },
                      child: Text(
              message.message,
              style: TextStyle(color: isMe ? Colors.blue : Colors.blue),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        ) :Container(): Card(
          color: Color(0xFF403477),
          child: Container(
            color: Color(0xFF403477),
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.message,
                style: TextStyle(color: isMe ? Colors.white : Colors.white),
                textAlign: isMe ? TextAlign.start : TextAlign.end,
              ),
            ),
          ),
        ),

        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              height: 3,
              width: 3,
              decoration: BoxDecoration(
                  color: Color( 0xFFFEB904),
                  shape: BoxShape.circle
              ),
            ),
            // Text(message.username),
            Text(date, style: TextStyle(color:Color( 0xFFFEB904)))
          ],
        ),
      ],
    );
  }
}

