import 'package:finbul/Model/Message.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:finbul/Widgets/photoView.dart';
import 'package:finbul/Widgets/recordPlayer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatFiles extends StatefulWidget {
  final String idUser;
  final user;

  const ChatFiles({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  _ChatFilesState createState() => _ChatFilesState();
}

class _ChatFilesState extends State<ChatFiles> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor:  Color(0xFF372C6A),
        appBar: AppBar(
          title: Text(widget.user.name ?? ''),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back, color:  Color( 0xFFFEB904),)),
          bottom: PreferredSize(
              child: TabBar(
                unselectedLabelColor: Color(0xFF705FBB),
                labelColor:  Color(0xFFFEB904),
                indicatorColor: Color(0xFFFEB904),
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    child: Text('MEDIA'),
                  ),
                  Tab(
                    child: Text('DOCS'),
                  ),
                  Tab(
                    child: Text('LINKS'),
                  ),
                ],
              ),
              preferredSize: Size(double.infinity, 30)),
          backgroundColor: Color(0xFF372C6A),
        ),
        body: TabBarView(children: [
          MediaWidget(idUser: widget.user.userid, user: widget.user),
          DocWidget(idUser: widget.user.userid, user: widget.user),
          LinkWidget(idUser: widget.user.userid, user: widget.user)
        ]),
      ),
    );
  }
}

class MediaWidget extends StatelessWidget {
  final String idUser;
  final user;

  const MediaWidget({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    var network = Provider.of<DataProvider>(context, listen: false);
    return Container(
      child: StreamBuilder<List<Message>>(
        stream:  FirebaseApi.getMessages(idUser,  '${network.firebaseUserId}-${user.userid}',  '${user.userid}-${network.firebaseUserId}'),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages.isEmpty
                    ? buildText('No photos found.')
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.message.contains('https://') ||
                        message.message.contains('http://')
                        ? data.categorizeUrl(message.message) == 'image'
                        ? Hero(
                      tag: message.message,
                      child: GestureDetector(
                        onTap: (){
                          return  Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return PhotoView(
                                  message.message,
                                  message.message,
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

                        },                     child: Padding(
                          padding: const EdgeInsets.only(bottom:2),
                          child: Container(
                            height: 150,
                            child: Image.network(
                              message.message,
                              fit: BoxFit.cover,
                            )),
                        ),
                      ),
                    ): data.categorizeUrl(message.message) == 'audio'?
                    Padding(
                      padding:  EdgeInsets.only(bottom:4, top: 4,left: MediaQuery.of(context).size.width/4),
                      child: GestureDetector(
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

                      ),
                    )
                        : Container()
                        : Container();
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  );
}

class DocWidget extends StatelessWidget {
  final String idUser;
  final user;

  const DocWidget({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var datas = Provider.of<Utils>(context);
    var data = Provider.of<DataProvider>(context);
    var network = Provider.of<DataProvider>(context, listen: false);
    return Container(
      child: StreamBuilder<List<Message>>(
        stream:  FirebaseApi.getMessages(idUser,  '${network.firebaseUserId}-${user.userid}',  '${user.userid}-${network.firebaseUserId}'),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;
                return messages.isEmpty
                    ? buildText('No docs found.')
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.message.contains('https://') ||
                        message.message.contains('http://')
                        ? data.categorizeUrl(message.message) == 'doc'
                        ? InkWell(
                        onTap: () {
                          datas.opeLink(message.message);
                        },
                        child: Card(
                          child: Tab(
                            text: 'Open this Document/Download',
                            icon: Icon(FontAwesomeIcons.file , size: 40),
                          ),
                        ))
                        : Container()
                        : Container();
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  );
}

class LinkWidget extends StatelessWidget {
  final String idUser;
  final user;

  const LinkWidget({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<DataProvider>(context, listen: false);
    var data = Provider.of<DataProvider>(context);
    var datas = Provider.of<Utils>(context);
    return Container(
      child: StreamBuilder<List<Message>>(
        stream:  FirebaseApi.getMessages(idUser,  '${network.firebaseUserId}-${user.userid}',  '${user.userid}-${network.firebaseUserId}'),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(
     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white10),
));
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages.isEmpty
                    ? buildText('No links found.')
                    : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.message.contains('https://') ||
                        message.message.contains('http://')
                        ? data.categorizeUrl(message.message) == 'link'
                        ? InkWell(
                        onTap: () {
                          datas.opeLink(message.message);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(message.message, style: TextStyle(color: Colors.blue)),
                        ))
                        : Container()
                        : Container();
                  },
                );
              }
          }
        },
      ),
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  );
}
