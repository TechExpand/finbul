import 'package:fin_bul/Screen/Splash.dart';
import 'package:fin_bul/Screen/SignUp.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Screen/HomePage.dart';
import 'Screen/Login.dart';
import 'Utils/Provider.dart';

void main()  {
  getfireBase()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Provider.debugCheckInvalidValueType = null;
  }
  getfireBase();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataProvider>(
      create: (context) => DataProvider(),
    ),
    ChangeNotifierProvider<WebServices>(
      create: (context) => WebServices(),
    ),
    ChangeNotifierProvider<Utils>(
      create: (context) => Utils(),
    ),
  ], child: MyApp())); // MyApp(widget)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finbul',
      theme: ThemeData(
        accentColor: Colors.white10,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
    );
  }

}
