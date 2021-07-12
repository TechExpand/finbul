import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:finbul/Model/UserChat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Chat.dart';


class ListenIncoming extends StatefulWidget {
  @override
  _ListenIncomingState createState() => _ListenIncomingState();
}

class _ListenIncomingState extends State<ListenIncoming> {
  PageController _myPage;
  @override


  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);

    var network = Provider.of<DataProvider>(context, listen: false);
    Widget buildText(String text) => Padding(
      padding: const EdgeInsets.all(100.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center,
      ),
    );
    List<UserChat> user;


    return ListView(
        children: [

          Container(
            height: MediaQuery.of(context).size.height,
            child:
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream:
                    FirebaseApi.userChatStream(network.firebaseUserId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        user = snapshot.data.docs
                            .map((doc) => UserChat.fromMap(doc.data(), doc.id))
                            .toList();
                        List<UserChat> chatData = [];
                        for (var v in user) {
                          chatData.add(v);
                        }
                        chatData
                          ..sort((b, a) =>
                              a.lastMessageTime.compareTo(b.lastMessageTime));
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return buildText(
                                  'Something Went Wrong Try later');
                            } else {
                              final users = chatData;
                              if (users.isEmpty) {
                                return buildText('No Users Found');
                              } else
                                return Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var date = data.compareDate(
                                          users[index].lastMessageTime);

                                      return Container(
                                        height: 75,
                                        child: ListTile(
                                          onTap: () {
                                            // users[index].idUser
                                            FirebaseApi.updateUsertoRead(
                                                idUser: users[index].userid,
                                                idArtisan:
                                                network.firebaseUserId);
                                            Navigator.of(context)
                                                .push( PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation){
                                                return ChatPage(
                                                    user: users[index]);
                                              },
                                               transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },
                                            ));
                                          },
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                users[index].urlAvatar),
                                          ),
                                          title: Text(users[index].name, style: TextStyle(color: Colors.white),),
                                          subtitle: Text(
                                              users[index]
                                                  .lastMessage
                                                  .toString()
                                                  .isEmpty ||
                                                  users[index]
                                                      .lastMessage ==
                                                      null
                                                  ? 'No Message Yet'
                                                  : users[index].lastMessage,
                                              style: TextStyle(
                                                  color: users[index].read
                                                      ? Colors.white70
                                                      : Colors.white,
                                                  fontWeight: users[index].read
                                                      ? null
                                                      : FontWeight.bold),maxLines: 1,softWrap: true, overflow: TextOverflow.ellipsis,),
                                          trailing: Text(date, style: TextStyle(color: Colors.white),),
                                          //  subtitle:  Text(users[index].lastMessageTime),
                                        ),
                                      );
                                    },
                                    itemCount: users.length,
                                  ),
                                );
                            }
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),

          )
        ],
    );
  }
}
