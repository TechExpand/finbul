import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  String password = '';
  int count = 10;
  String firebaseUserId = '';
  String overview = '';
  String phone = '';
  bool focusValue = false;
  String description = '';
  bool focusValue1 = false;
  bool splash = false;
  String selectedValue = '30min';
  String productBio = '';
  int productPrice = 0;
  List subcat = [];

  bool isWriting = false;
  int selectedPage = 0;
  String emails = '';
  String businessName = '';
  String homeAddress = '';
  String officeAddress = '';
  String token = '';
  String firstName = '';
  String lastName = '';
  String artisanVendorChoice = '';
  int selected;
  bool passwordObscure = true;
  bool showCallToAction = true;

  set setCallToActionStatus(bool newVal) {
    showCallToAction = newVal;
    notifyListeners();
  }

  setDescription(value) {
    description = value;
    notifyListeners();
  }


  setseleted(value){
    selected = value;
    notifyListeners();
  }
  //change password obcure text
  setSelectedBottomNavBar(value) {
    selectedPage = value;
    notifyListeners();
  }

  //change password obcure text
  setPassWordObscure(value) {
    passwordObscure = value;
    notifyListeners();
  }

  var userItems = [];
  var userItems1 = [];
  setUseritems(v1,v2){
    userItems = v1 + v2;
    notifyListeners();
  }

  setUseritems1(v1,v2){
    userItems1 = v1 + v2;
    notifyListeners();
  }


// combine all otp textfield as one
  setToken(value) {
    token = value;
    notifyListeners();
  }

  // check if  textfield firstNAme is empty or not
  setFirstName(value) {
    firstName = value;
    notifyListeners();
  }

  setSubCat(value) {
    subcat.add(value);
    notifyListeners();
  }

  setdelSubCat(value) {
    subcat.remove(value);
    notifyListeners();
  }

  setclrSubCat() {
    subcat.clear();
    notifyListeners();
  }

  setOverView(value) {
    overview = value;
    notifyListeners();
  }



  // check if   BVN is empty or not

  // check if  textfield lastName is empty or not
  setLastName(value) {
    lastName = value;
    notifyListeners();
  }

  // check if  textfield homeAdress is empty or not
  sethomeAdress(value) {
    homeAddress = value;
    notifyListeners();
  }

  setSelectedValue(value) {
    selectedValue = value;
    notifyListeners();
  }

  setProductBio(value) {
    productBio = value;
    notifyListeners();
  }

  setProductPrice(value) {
    productPrice = value;
    notifyListeners();
  }

// check if  textfield officeAdress is empty or not
  setofficeAddress(value) {
    officeAddress = value;
    notifyListeners();
  }

  // check if  textfield email is empty or not
  setEmail(value) {
    emails = value;
    notifyListeners();
  }

  // check if  textfield password is empty or not
  setPassword(value) {
    password = value;
    notifyListeners();
  }

// check if  textfield number is empty or not



//end of **of otp textfield** function

//otp count down

  void setUserID(id) {
    firebaseUserId = id;
    notifyListeners();
  }
  //
  // Future<void> onJoin(
  //     {channelID,
  //     callerId,
  //     context,
  //     reciever,
  //     userID,
  //     myusername,
  //     myavater,
  //     calltype}) async {
  //   // update input validation
  //   var data = Provider.of<CallApi>(context, listen: false);
  //   if (channelID.isNotEmpty) {
  //     // await for camera and mic permissions before pushing video page
  //     await _handleCameraAndMic(Permission.camera);
  //     await _handleCameraAndMic(Permission.microphone);
  //     // push video page with given channel name
  //     await data.uploadMessage(
  //       context: context,
  //       channelId: channelID,
  //       idUser: userID,
  //       calltype: calltype,
  //       callerId: callerId,
  //       urlAvatar: myavater,
  //       urlAvatar2: reciever,
  //       username: myusername,
  //     );
  //   }
  // }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  setWritingTo(bool val) {
    isWriting = val;
    notifyListeners();
  }

  setSplash(bool val) {
    splash = val;
    notifyListeners();
  }

bool overlay = false;
  setOverLay(bool val) {
    overlay = val;
    notifyListeners();
  }

  String categorizeUrl(String s) {
    if (s.contains('https://firebasestorage.googleapis.com')) {
      var pos = s.lastIndexOf('.');
      String result = s.substring(pos + 1, s.length).toString().toLowerCase();
      if (result.contains('jpg') ||
          result.contains('jpeg') ||
          result.contains('png') ||
          result.contains('gif')) {
        return 'image';
      } else if (result.contains('pdf') ||
          result.contains('doc') ||
          result.contains('docx') ||
          result.contains('xls') ||
          result.contains('xlsx') ||
          result.contains('ods') ||
          result.contains('txt') ||
          result.contains('csv') ||
          result.contains('html')) {
        return 'doc';
      } else if (result.contains('wav') || result.contains('mp3')) {
        return 'audio';
      }
    } else {
      return 'link';
    }
  }
}
