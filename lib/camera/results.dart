
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ResultPage extends StatefulWidget {
  DocumentReference doc;
  static String _url;
  ResultPage(id){
    this.doc=id;
  }

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String stateUrl;
  String getResult(){
    widget.doc.get().then((datasnapshot){
      print("checking condition");
      if(datasnapshot.exists){
        String url=datasnapshot.data["result_url"];
        if(url== null){
          print("result has not generated");
          return null;
        }
        // Image temp= Image.network(url);
        // print("image loaded")
           ResultPage._url=url;
           setState(() {
            this.stateUrl=url; 
           });
           return url;
      }else{
         print("document does not exist");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: ListView(
            children: [Container(
          child: getResult() != null?Image.network(stateUrl):Text("waiting for data to load"),
        ),
            ]),
    );
  }
}