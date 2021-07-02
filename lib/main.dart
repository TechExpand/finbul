import 'package:fin_bul/Screen/Splash.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:fin_bul/Utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Utils/Provider.dart';

void main()async{
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

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}




class MyAppState extends State{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(0xFF372C6A),
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
