import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Auth {
  Future<AuthResult> signInEmailPassword(
      String email, String password, BuildContext buildContext) async {
    try {
      AuthResult authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return authResult;
    } catch (e) {
      errorDialog(buildContext, e.toString());
      return null;
    }
  }

  errorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "Something Went Wrong",
              style: Theme.of(context).textTheme.display1,
            ),
            content: Text(message, style: Theme.of(context).textTheme.display3),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 80,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      child: Text(
                        "OK",
                        style:  Theme.of(context).textTheme.display1,
                      ),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
