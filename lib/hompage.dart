import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera_app/newpage.dart';
import "camera/camera_page.dart";
import "message.dart";

class HomePage extends StatefulWidget {
  static bool signedIn=false;
  static FirebaseUser user=null;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  openMessage(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context){
        return Material(
          // color: Colors.green[200],
          child: Message((HomePage.user != null?HomePage.user.displayName:"pankaj")),
        );
      } 
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Image Sender"),
        // backgroundColor: Color.fromRGBO(106, 20, 145,1),
        backgroundColor: Colors.blue,
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
                title: HomePage.signedIn==false?Text("SIGN IN",style: TextStyle(fontSize: 18,)):Text("SIGN OUT",
                style: TextStyle(fontSize: 18,)),
                trailing: Icon(Icons.dock,size: 30,),
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
              title: Text("CLOSE",
              style: TextStyle(fontSize: 18,)),
              trailing: Icon(Icons.close,size: 30,),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: Material(
        child: Stack(
          children: <Widget>[
            
            ListView(
                      children:[ 
                Column(
                children: <Widget>[
                  Container(
                   
                    width: 290,
                    height: 380,
                    // child: Image.asset("assets/hompage.png"),
                    // child: Image.asset("assets/home_man.gif"),
                    child: HomePage.user != null?Image.asset("assets/clothes.png"):Image.asset("assets/front.jpg"),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(30),
                  // ),
                   Container(
                    height: 65,
                    // color: Color.fromRGBO(255,117,24, 1),

                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(251,80,27, 1),
                      child: Icon(
                        Icons.message,
                        size: 30,
                      ),
                      onPressed: openMessage,
                    ),
                  ),
                  HomePage.user!=null? Container(
                    // color: Colors.green[200],
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    
                    // margin: EdgeInsets.fromLTRB(55, 46, 0,0),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(21, 16, 21, 16),
                              child: Container(
                                // alignment: Alignment.bottomLeft,
                                //height: 40,
                                //width: 40,
                                child: InkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    // highlightColor:
                                        // Colors.green[400], //Colors.greenAccent[300],
                                    // splashColor: Colors.greenAccent[600],
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => BackdropPage(),
                                      ));
                                    },
                                    child: Row(children: <Widget>[
                                      Text("go to camera page",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),),
                                      IconButton(icon: Icon(Icons.home, size: 30,), onPressed: null),
                                    ])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Text("Please Sign in",style: Theme.of(context).textTheme.display1,),
                  ):Container(
                    
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 30, 30),
                      child: Text("Sign In to Access the features",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal
                      ),
                      )),
                    // child: Image.asset("assets/please_sign_in.png")
                  ),
                ],
              ),
              
                      ]),
            //           Positioned(
            //   bottom: 125,
            //   right: 150,
            //   child: Container(
            //         height: 65,
            //         // color: Color.fromRGBO(255,117,24, 1),

            //         child: FloatingActionButton(
            //           backgroundColor: Color.fromRGBO(251,80,27, 1),
            //           child: Icon(
            //             Icons.message,
            //             size: 30,
            //           ),
            //           onPressed: openMessage,
            //         ),
            //       ),
            // ),
          ],
        ),
      ),
    );
  }
}
