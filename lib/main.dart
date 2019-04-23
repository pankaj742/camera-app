//import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
//import 'package:path/path.dart';
//import 'package:navigation/newpage.dart';
import "hompage.dart";


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
      // routes: {
      //   "/a": (BuildContext context)=> NewPage("new page"),
      // }
    );
  }
}