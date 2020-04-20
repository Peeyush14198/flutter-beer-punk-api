import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frogbit/screens/root_screen.dart';
import 'package:frogbit/util/auth.dart';
import 'package:frogbit/util/functions.dart';

import 'package:frogbit/widgets/custom_fade_animation.dart';
import 'package:frogbit/widgets/custom_loader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  bool loader = false;
  TextEditingController email = new TextEditingController();
  TextEditingController forgot = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool enterEmail = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> validateAndSave() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        loader = true;
      });
      try {
        AuthResult authResult = await Auth().signInEmailPassword(
            email.text.trim(), password.text.trim(), context);
        if (authResult != null) {
          CustomFunctions().removeAllRoutes(context, RootScreen());
          // Auth().validateUser(authResult, context);
        } else {
          setState(() {
            loader = false;
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          loader = false;
        });
      }
    }
    return false;
  }

  String validateEmail(String value) {
    value = value.trim();
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: loader
          ? CustomLoaderWidget()
          : Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomFadeAnimation(
                      child: emailPasswordWidget(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomFadeAnimation(
                      child: submitButton(),
                    ),
                  ],
                ),
              )),
    );
  }

  Widget entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: Theme.of(context).textTheme.display1,
            autofocus: false,
            validator: isPassword ? validatePassword : validateEmail,
            controller: isPassword ? password : email,
            obscureText: isPassword ? true : false,
            decoration: InputDecoration(
              hintText: isPassword ? 'Password' : 'Email',
              hintStyle: Theme.of(context).textTheme.display3,
              border: InputBorder.none,
              prefixIcon: Icon(
                isPassword ? MdiIcons.security : Icons.mail,
                color: Theme.of(context).primaryColor,
              ),
              fillColor: Colors.black,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () => validateAndSave(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            'or',
            style: Theme.of(context).textTheme.display2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget emailPasswordWidget() {
    return Column(
      children: <Widget>[
        entryField("Email id"),
        entryField("Password", isPassword: true),
      ],
    );
  }
}
