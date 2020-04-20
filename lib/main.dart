import 'package:flutter/material.dart';
import 'package:frogbit/screens/root_screen.dart';
import 'package:frogbit/util/functions.dart';
import 'package:frogbit/util/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
        providers: [
          
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ],
        child: MyApp(),
      ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frogbit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: CustomFunctions().hexToColor("#1d1f2e"),
          backgroundColor: CustomFunctions().hexToColor("#262833"),
          // backgroundColor: CustomFunctions().hexToColor("#1d1f2e"),
          primaryColor: Colors.deepOrange[500],
          cursorColor: Colors.deepOrange[500],
          disabledColor: Colors.white,
          // primaryColor: CustomFunctions().hexToColor("#67d5fe"),
          accentColor: CustomFunctions().hexToColor("#262833"),
          dividerColor: Colors.grey[400],
          // accentColor: CustomFunctions().hexToColor("#e32a76"),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: AppBarTheme(
              color: CustomFunctions().hexToColor("#1d1f2e"),
              textTheme: TextTheme(
                  title: TextStyle(color: Colors.white, fontSize: 17.0)),
              iconTheme: IconThemeData(color: Colors.deepOrange[500])),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
              title: TextStyle(color: Colors.white, fontSize: 15.0),
              display1: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
              button: TextStyle(
                  color: CustomFunctions().hexToColor("#1d1f2e"),
                  fontSize: 15.0),
              display2: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              display3: TextStyle(color: Colors.grey[400], fontSize: 13.0),
              display4: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              headline: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // color: CustomFunctions().hexToColor("#67d5fe"),
                  fontSize: 17.0))),
      home: RootScreen(),
    );
  }
}


