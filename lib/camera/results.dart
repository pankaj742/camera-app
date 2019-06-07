
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
  void initState(){
    super.initState();
    getResult();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: ListView(
            children: [Container(
          child: stateUrl != null?Image.network(stateUrl):
          Stack(children: <Widget>[
            Container(
              width: 350,
              height: 600,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.pinkAccent)
                ),
              child: 
                  // BoxFit(child: Image.asset("assets/loading3.gif")),
                  Text("waiting for data to load"),
            ),
          Container(
            margin: EdgeInsets.fromLTRB(40,0,0,0),
            child: Image.asset("assets/loading3.gif")),
          ],)
        ),
            ]),
    );
  }
}