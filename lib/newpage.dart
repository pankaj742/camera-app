import "package:flutter/material.dart";
import "package:camera_app/database_edit.dart";
import 'package:camera_app/sign_in.dart';

class NewPage extends StatelessWidget {
  var _pageType;
  String title;
  NewPage(this.title,this._pageType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body:_pageType=="sign in"? SignIn():DatabaseEdit(),
    );
  }
}