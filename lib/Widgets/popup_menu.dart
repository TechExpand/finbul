// import 'package:fixme/Screens/GeneralUsers/Chat/ChatFiles.dart';
// import 'package:fixme/Services/Firebase_service.dart';
// import 'package:fixme/Services/network_service.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Widgets/chatfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpMenu extends StatelessWidget {
  final String idUser;
  final user;
  final popData;
  final scaffoldKey;

  PopUpMenu({
    this.user,
    this.popData,
    @required this.idUser,
    @required this.scaffoldKey,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<DataProvider>(context, listen: false);

    return PopupMenuButton(
        offset: const Offset(0, 10),
        elevation: 5,
        icon: Icon(
          Icons.more_vert,
          color:  Color( 0xFFFEB904),
          size: 28,
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 2,
                  child: InkWell(
                    onTap: () {
                      FirebaseApi.clearMessage(
                          idUser,
                          '${network.firebaseUserId}-${user.userid}',
                          '${user.userid}-${network.firebaseUserId}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Clear Message'),
                    ),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ChatFiles(idUser: user.userid, user: user);
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
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Media, links, and docs'),
                    ),
                  )),
            ]);
  }

}
