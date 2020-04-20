
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frogbit/screens/login_screen.dart';
import 'package:frogbit/screens/splah_screen.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // GraphQLClient client;
  @override
  void initState() {
    // client = GraphQLProvider.of(context).value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasData && snapshot.data.uid != null) {
          return SplashScreen(
          
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
