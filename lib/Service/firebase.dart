import 'package:finbul/Model/Message.dart';
import 'package:finbul/Model/post.dart';
import 'package:finbul/Model/user.dart';
import 'package:finbul/Screen/HomePage.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';

class FirebaseApi {
  static Stream<List<MyUser>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(MyUser.fromJson));



  static Future uploadmessage(
      String idUser, String idArtisan, String message, context, chatId) async {
    var network = Provider.of<DataProvider>(context, listen: false);
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    final newMessage = Message(
      chatId: chatId ?? '',
      idUser: network.firebaseUserId?? '',
      urlAvatar: 'https://uploads.fixme.ng/originals/${'network.profilePicFileName'}' ??
          '',
      username: network.firstName ?? '',
      message: message ?? '',
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
    await refMessages2.add(newMessage.toJson());

    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': '$message',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': '$message',
      'read': false,
    });
  }

  static Future uploadImage(
      String idUser, idArtisan, message, context, chatId) async {
    var network = Provider.of<DataProvider>(context, listen: false);
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(message.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(message.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newMessage = Message(
          chatId: chatId ?? '',
          idUser: network.firebaseUserId ?? '',
          urlAvatar:'https://uploads.fixme.ng/originals/${'network.profilePicFileName'}' ?? '',
          username: network.firstName ?? '',
          message: imageurl ?? '',
          createdAt: DateTime.now(),
        );

        refMessages.add(newMessage.toJson());
        await refMessages2.add(newMessage.toJson());
      });
    });





    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });
  }




  static Future uploadComment2(phone,{String id, String message,postid, name,username , picture, status, image, context}) async {
    var network = Provider.of<DataProvider>(context, listen: false);
    final refPost =
    FirebaseFirestore.instance.collection('PostComment');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(image.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(image.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        await refPost.doc().set({
          'userid': id,
          'imageSent': imageurl,
          'id': postid,
          'message': message,
          'status':status,
          'username': username,
          'phone': phone,
          'picture': picture,
          'name': name,
          'createdAt': DateTime.now(),
          'uplike': '0',
          'downlike': '0',
        });
      });
    });
  }






  static Future uploadPost2({String id, String message, name,username , picture, phone, status, image, context}) async {
    var network = Provider.of<DataProvider>(context, listen: false);
    final refPost =
    FirebaseFirestore.instance.collection('Post');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(image.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(image.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newPost = Post(
            userid: id,
            message: message,
            name: name,
            status: status,
            imageSent: imageurl,
            username: username,
            phone: phone,
            picture: picture,
            createdAt: DateTime.now(),
        thumbup: '0',
        thumbdown: '0',
            comment: '0',
        );

        await  refPost.add(newPost.toJson());
      });
    });
  }





  static Future uploadRecord(
      String idUser, idArtisan, message, context, chatId) async {
    var network = Provider.of<DataProvider>(context, listen: false);
    final refMessages =
    FirebaseFirestore.instance.collection('chats/$idUser/messages');
    final refMessages2 =
    FirebaseFirestore.instance.collection('chats/$idArtisan/messages');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(message.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(message.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        final newMessage = Message(
          chatId: chatId ?? '',
          idUser: network.firebaseUserId?? '',
          urlAvatar:'https://uploads.fixme.ng/originals/${'network.profilePicFileName'}' ?? '',
          username: network.firstName ?? '',
          message: imageurl ?? '',
          createdAt: DateTime.now(),
        );

        refMessages.add(newMessage.toJson());
        await refMessages2.add(newMessage.toJson());
      });
    });
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    final refArtisan =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refArtisan.doc(idUser).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });

    await refUsers.doc(idArtisan).update({
      UserField.lastMessageTime: DateTime.now(),
      'lastMessage': 'A File',
      'read': false,
    });
  }

  static Stream<List<Message>> getMessages(String idUser, chatId1, chatId2) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .where('chatId', whereIn: [chatId1, chatId2])
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static clearMessage(String idUser, chatId1, chatId2) {
    var documentReference = FirebaseFirestore.instance
        .collection('chats/$idUser/messages')
        .where('chatId', whereIn: [chatId1, chatId2]);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }


  static Future addUserChat({
    idUser,
    name,
    urlAvatar,
    docid,
    idArtisan,
    name2,
    urlAvatar2,
    userMobile,
    artisanMobile,
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    final refAritisan =
    FirebaseFirestore.instance.collection('UserChat/$idUser/individual');
    await refUsers.doc(idUser).set({
//      'bid_id': bidData.bid_id ?? '',
//      'project_id': bidData.job_id ?? '',
//      'project_owner_user_id': bidData.project_owner_user_id ?? '',
//      'service_id': bidData.service_id ?? '',
      'chatid': idArtisan,
      'read': false,
      'userid': idUser,
      'name': name,
      'block': false,
      'userMobile': userMobile,
      'lastMessage': 'No Message yet',
      'urlAvatar': urlAvatar,
      'lastMessageTime': DateTime.now(),
    });
    await refAritisan.doc(idArtisan).set({
//      'bid_id': bidData.bid_id ?? '',
//      'project_id': bidData.job_id ?? '',
//      'project_owner_user_id': bidData.project_owner_user_id ?? '',
//      'service_id': bidData.service_id ?? '',
      'chatid': idUser,
      'read': false,
      'block': false,
      'userid': idArtisan,
      'lastMessage': 'No Message yet',
      'name': name2,
      'userMobile': artisanMobile,
      'urlAvatar': urlAvatar2,
      'lastMessageTime': DateTime.now(),
    });
  }





  /*  static Stream<List<User>> SearchUserChatStream(chatid) => FirebaseFirestore.instance
      .collection('UserChat/$chatid/individual')
      .where('chatid', isEqualTo: chatid).where('')
      .snapshots()
      .transform(Utils.transformer(User.fromJson)); */

  static Stream<QuerySnapshot> userChatStream(chatid) {
    print(chatid);
    print(chatid);
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userNotificatioStream(id) {
    var data = FirebaseFirestore.instance
        .collection('Notification')
        .where('userid', isEqualTo: id).orderBy('createdAt', descending: true);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userCheckNotifyStream(id) {
    var data = FirebaseFirestore.instance
        .collection('CheckNotify')
        .where('userid', isEqualTo: id);
    return data.snapshots();
  }


  static clearCheckNotify(String id) {
    var documentReference = FirebaseFirestore.instance
        .collection('CheckNotify')
        .where('userid' , isEqualTo: id);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }



  static Stream<QuerySnapshot> userCheckChatStream(id) {
    var data = FirebaseFirestore.instance
        .collection('CheckChat')
        .where('userid', isEqualTo: id);
    return data.snapshots();
  }


  static Stream<QuerySnapshot> postStream() {
    var data = FirebaseFirestore.instance
        .collection('Post').orderBy('createdAt', descending: true);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> mypostStream(id) {
    var data = FirebaseFirestore.instance
        .collection('Post').where( 'userid',isEqualTo: id).orderBy('createdAt', descending: true);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> postCommentStream(id){
    var data = FirebaseFirestore.instance
        .collection('PostComment').where('id' , isEqualTo: id).orderBy('createdAt', descending: true);
    return data.snapshots();
  }


  static Stream<QuerySnapshot> profileStream(id){
    var data = FirebaseFirestore.instance
        .collection('Profile').where('userid' , isEqualTo: id);
    return data.snapshots();
  }



  static Stream<QuerySnapshot> watchListStream(id){
    var data = FirebaseFirestore.instance
        .collection('WatchList').where('userid' , isEqualTo: id);
    return data.snapshots();
  }




  static Stream<QuerySnapshot> bearbulltotalStream(){
    var data = FirebaseFirestore.instance
        .collection('Post');
    return data.snapshots();
  }






  static singlePostStream(id){
    var data = FirebaseFirestore.instance
        .collection('Post').doc(id);
    return data.snapshots();
  }

  static clearCheckChat(String id) {
    var documentReference = FirebaseFirestore.instance
        .collection('CheckChat')
        .where('userid' , isEqualTo: id);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }




  static Future uploadWatchList({
      String id, symbol}) async {
    final refMessages = FirebaseFirestore.instance.collection('WatchList');

    await refMessages.doc().set({
      'symbol': symbol,
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }


  static Future uploadCheckNotify(
      String id,) async {
    final refMessages = FirebaseFirestore.instance.collection('CheckNotify');

    await refMessages.doc().set({
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }

  static Future uploadCheckChat(
      String id,) async {
    final refMessages = FirebaseFirestore.instance.collection('CheckChat');

    await refMessages.doc().set({
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }


  static Future thumbUp({number,String id})async{
    print(id);
    final refMessages = FirebaseFirestore.instance.collection('PostComment');

    await refMessages.doc(id).update({
      // 'createdAt': DateTime.now(),
      'uplike': number.toString(),
    });
}

  static Future thumbDown({number,String id})async{
    final refMessages = FirebaseFirestore.instance.collection('PostComment');
    await refMessages.doc(id).update({
      // 'createdAt': DateTime.now(),
      'downlike': number.toString(),
    });
  }


  static Future thumbUpPost({number,String id})async{
    print(id);
    final refMessages = FirebaseFirestore.instance.collection('Post');

    await refMessages.doc(id).update({
      // 'createdAt': DateTime.now(),
      'uplike': number.toString(),
    });
  }

  static Future thumbDownPost({number,String id})async{
    final refMessages = FirebaseFirestore.instance.collection('Post');
    await refMessages.doc(id).update({
      // 'createdAt': DateTime.now(),
      'downlike': number.toString(),
    });
  }

  static Future uploadpost({
      String id, String message, name,username , picture, phone, status,context, scaffoldkey}) async {
    final refMessages = FirebaseFirestore.instance.collection('Post');

    await refMessages.doc().set({
      'userid': id,
      'message': message,
      'name': name,
      'status': status,
      'username': username,
      'phone': phone,
      'picture': picture,
      'createdAt': DateTime.now(),
      'uplike': '0',
      'downlike': '0',
      'comment': '0',
    });
    Navigator.pop(context);
    
    scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('Successfully Uploaded')));
  }



  static Future uploadpostRetweet({
    String id, String message, name,username , picture, phone, status,context,scaffoldkey}) async {
    final refMessages = FirebaseFirestore.instance.collection('Retweet');

    await refMessages.doc().set({
      'userid': id,
      'message': message,
      'name': name,
      'status': status,
      'username': username,
      'phone': phone,
      'picture': picture,
      'createdAt': DateTime.now(),
      'uplike': '0',
      'downlike': '0',
      'comment': '0',
    });
    Navigator.pop(context);
     scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('Successfully Uploaded')));
  }


  static Future uploadpostComment(phone, {
    String id, String message, name, context, postid, username,status, picture,scaffoldkey}) async {
    final refMessages = FirebaseFirestore.instance.collection('PostComment');

    await refMessages.doc().set({
      'userid': id,
      'id': postid,
      'message': message,
      'status':status,
      'username': username,
      'phone': phone,
      'picture': picture,
      'name': name,
      'createdAt': DateTime.now(),
      'uplike': '0',
      'downlike': '0',
    });
    Navigator.pop(context);
    scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('Successfully Uploaded')));
  }


  static Future uploadNotification(
      String id, String message, type, name, jobId, bidId, bidderId, artisanId, budget) async {
    final refMessages = FirebaseFirestore.instance.collection('Notification');

    await refMessages.doc().set({
      'userid': id,
      'message': message,
      'jobId': jobId,
      'type': type,
      'name': name,
      'artisanId': artisanId,
      'bidded': 'bid',
      'bidderId': bidderId ?? '',
      'bidId': bidId ?? '',
      'budget': budget??'',
      'createdAt': DateTime.now(),
    });
  }

  static Future deleteWatchList(String id) async {
    final refMessages = FirebaseFirestore.instance.collection('WatchList');
    await refMessages.doc(id).delete();
  }


  static Future deletePost(String id) async {
    final refMessages = FirebaseFirestore.instance.collection('Post');
    await refMessages.doc(id).delete();
  }


  static Future updatePost(String id, message) async {
    final refMessages = FirebaseFirestore.instance.collection('Post');
    await refMessages.doc(id).update({
      'comment': message.toString(),
    });
  }

  static Stream<QuerySnapshot> userChatStreamUnread(chatid) {
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid)
        .where('read', isEqualTo: false);
    return data.snapshots();
  }

  static Stream<QuerySnapshot> userChatStreamread(chatid) {
    var data = FirebaseFirestore.instance
        .collection('UserChat/$chatid/individual')
        .where('chatid', isEqualTo: chatid)
        .where('read', isEqualTo: true);
    return data.snapshots();
  }

  static updateUsertoRead({
    String idUser,
    String idArtisan,
  }) async {
    final refUsers =
    FirebaseFirestore.instance.collection('UserChat/$idArtisan/individual');
    await refUsers.doc(idUser).update({
      'read': true,
    });
  }



 static Future Login(String email, password, context,scaffoldkey)async{
   DataProvider provide  = Provider.of<DataProvider>(context, listen: false);
 try {
   UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email,
       password: password
   );
   if(userCredential.user != null){
     Navigator.pop(context);
     print(userCredential.user.uid);
     provide.setUserID(userCredential.user.uid);
     Navigator.push(context, PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation){
       return HomePage();
     }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));

    return userCredential.user.uid;
   }
 } on FirebaseAuthException catch (e) {
   if (e.code == 'user-not-found') {
     Navigator.pop(context);
       scaffoldkey.currentState.showSnackBar(SnackBar(content:Text(e.code.toString().replaceAll('-', ' '))));

   } else if (e.code == 'wrong-password') {
     Navigator.pop(context);
      scaffoldkey.currentState.showSnackBar(SnackBar(content:Text(e.code.toString().replaceAll('-', ' '))));


   }else{
     Navigator.pop(context);
      scaffoldkey.currentState.showSnackBar(SnackBar(content:Text(e.code.toString().replaceAll('-', ' '))));

     
   }
 }
}



  static Future updateProfile(String id, name) async {
    final refMessages = FirebaseFirestore.instance.collection('Profile');

    await refMessages.doc(id).update({
      'name': name,
    });
  }





  static Future updateImage(id, paths, context) async {
    final refMessages = FirebaseFirestore.instance.collection('Profile');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(paths.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(paths.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        refMessages.doc(id).update({
          'picture': imageurl,
        });
      });
    });
    // _scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     content: Text('Profile picture updated'),
    //     backgroundColor: Theme.of(context).errorColor,
    //   ),
    // );
  }





  static Future updateCoverImage(id, paths, context) async {
    final refMessages = FirebaseFirestore.instance.collection('Profile');

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(paths.path)}');

    UploadTask uploadTask = storageReferenceImage.putFile(File(paths.path));
    uploadTask.then((res) {
      storageReferenceImage.getDownloadURL().then((imageurl) async {
        refMessages.doc(id).update({
          'coverImage': imageurl,
        });
      });
    });
  }






  static sendPassWordResetEmail(email, _scaffoldKey, context){
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('Sent Successfully. Check your mail inbox')));
      });}
    on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('This user does not exist.')));
      }
    }}







  static Future createProfile(String id, username, name, number) async {
    final refMessages = FirebaseFirestore.instance.collection('Profile');

    await refMessages.doc(id).set({
      'userid': id,
      'name': name,
      'number': number,
      'coverImage': '',
      'picture': 'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg',
      'username': username,
      'createdAt': DateTime.now(),
    });
  }




  static Future register(String email ,  password, username, name, number,context, _scaffoldkey)async{
    DataProvider provide  = Provider.of<DataProvider>(context,  listen: false);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if(userCredential.user != null){
        Navigator.pop(context);
        print(userCredential.user.uid);
        provide.setUserID(userCredential.user.uid);
        createProfile(userCredential.user.uid,username, name , number);
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation){
          return HomePage();
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
        return userCredential.user.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
         _scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('The password provided is too weak.')));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
         _scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('The account already exists for that email.')));
    
        print('The account already exists for that email.');
      }else{
        Navigator.pop(context);
        _scaffoldkey.currentState.showSnackBar(SnackBar(content:Text(e.code.toString().replaceAll('-', ' '))));

      }
    } catch (e) {
      print(e);
    }
  }





//  static Future uploadInMail(String idUser, String message, context) async {
//    var network = Provider.of<WebServices>(context, listen: false);
//    final refMessages =
//        FirebaseFirestore.instance.collection('inmail/$idUser/messages');
//
//    final newMessage = Message(
//      idUser: network.mobileDeviceToken ?? '',
//      urlAvatar: network.profilePicFileName ?? '',
//      username: network.firstName ?? '',
//      message: message ?? '',
//      createdAt: DateTime.now(),
//    );
//    await refMessages.add(newMessage.toJson());
//
//    final refUsers = FirebaseFirestore.instance.collection('UserChat');
//    await refUsers.doc(idUser).update(
//        {UserField.lastMessageTime: DateTime.now(), 'lastMessage': '$message'});
//  }
//
//  static Stream<List<Message>> getInMails(String idUser) =>
//      FirebaseFirestore.instance
//          .collection('inmails/$idUser/messages')
//          .orderBy(MessageField.createdAt, descending: true)
//          .snapshots()
//          .transform(Utils.transformer(Message.fromJson));
}
