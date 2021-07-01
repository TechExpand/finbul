import 'package:fin_bul/Model/Message.dart';
import 'package:fin_bul/Service/firebase.dart';
import 'package:fin_bul/Utils/Provider.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:fin_bul/Widgets/photoView.dart';
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
        appBar: AppBar(
          title: Text(widget.user.name ?? ''),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          bottom: PreferredSize(
              child: TabBar(
                indicatorWeight: 5,
                indicatorColor: Colors.white,
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
              return Center(child: CircularProgressIndicator());
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

                        },                     child: Container(
                          height: 150,
                          child: Image.network(
                            message.message,
                            fit: BoxFit.cover,
                          )),
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
              return Center(child: CircularProgressIndicator());
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
              return Center(child: CircularProgressIndicator());
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
