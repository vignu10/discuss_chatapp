import 'package:discuss/screens/LandingPage/LandingHelpers.dart';
import 'package:discuss/screens/LandingPage/Landingservices.dart';
import 'package:discuss/screens/LandingPage/landingUtils.dart';
import 'package:discuss/services/FirebaseOperations.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:discuss/constants/Constantcolors.dart';
import 'package:discuss/screens/Splashscreen/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:discuss/services/Authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
        theme: ThemeData(
            accentColor: constantColors.greenColor,
            fontFamily: 'poppins',
            canvasColor: Colors.transparent),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => Landingservices())
      ],
    );
  }
}
