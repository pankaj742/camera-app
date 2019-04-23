import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera_app/newpage.dart';
import "camera/camera_page.dart";

class HomePage extends StatefulWidget {
  static bool signedIn=false;
  static FirebaseUser user=null;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Sender"),
        backgroundColor: Colors.green[400],
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Material(
              color: Colors.pink[100],
              child: UserAccountsDrawerHeader(
                accountName: HomePage.user==null?Text("User"):Text(HomePage.user.displayName),
                accountEmail: HomePage.user==null?Text("Email"):Text(HomePage.user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.pink,
                  //minRadius: 60,
                  child: HomePage.user==null?Text("P"):Image.network(HomePage.user.photoUrl),
                ),
                // otherAccountsPictures: <Widget>[
                //   CircleAvatar(
                //   backgroundColor: Colors.white,
                //   child: Text("k"),
                // ),
                // ],
              ),
            ),
            ListTile(
                title: HomePage.signedIn==false?Text("Sign in"):Text("Sign out"),
                trailing: Icon(Icons.dock),
                onTap: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).pushNamed("/a");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          NewPage("Sign In", "sign in")));
                }),
            // ListTile(
            //     title: Text("Image Operations"),
            //     trailing: Icon(Icons.edit),
            //      onTap: null
            //      //() {
            //     //   Navigator.of(context).pop();
            //     //   //Navigator.of(context).pushNamed("/a");
            //     //   Navigator.of(context).push(MaterialPageRoute(
            //     //       builder: (BuildContext context) =>
            //     //           NewPage("Image Operations", "database edit")));
            //     // }
            //     ),
            ListTile(
              title: Text("Close"),
              trailing: Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: Material(
        child: ListView(
                  children:[ 
            Column(
            children: <Widget>[
              Container(
                width: 290,
                height: 410,
                child: Image.asset("assets/hompage.png"),
              ),
              Container(
                height: 65,
              ),
              HomePage.user!=null? Container(
                color: Colors.green[200],
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.yellowAccent[100],
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            //height: 40,
                            //width: 40,
                            child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                highlightColor:
                                    Colors.green[400], //Colors.greenAccent[300],
                                splashColor: Colors.greenAccent[600],
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => BackdropPage(),
                                  ));
                                },
                                child: Row(children: <Widget>[
                                  Text("go to camera page",
                                      style: Theme.of(context).textTheme.button),
                                  IconButton(icon: Icon(Icons.home), onPressed: null),
                                ])),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Text("Please Sign in",style: Theme.of(context).textTheme.display1,),
              ):Container(),
            ],
          ),
                  ]),
      ),
    );
  }
}
