import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'hompage.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
 static String _string="Click on Sign in Button";

  void _signIn() async{
    // setState(() {
    //  _string="please wait while it is loading" ;
    // });
     Navigator.of(context).push(MaterialPageRoute(
      builder:(BuildContext context){
        return Scaffold(
          //backgroundColor: Colors.white70,
          //backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.teal[200],
            child: Center(
              //color: Colors.green,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: null,
                    //value: 1,
                    //semanticsLabel: "please wait while uploading",
                  ),
                  Text("please wait while signing in"),
                ],
              ),
            ),
          ),
        );
      }
    ));

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = await _auth.signInWithCredential(credential);
  Navigator.of(context).pop();
  print("signed in " + user.displayName);
    setState(() {
     _string="wlecome Mr. ${user.displayName} click on \nsign out button to sign out ";
     HomePage.signedIn=true;
     HomePage.user=user;
    });
    //return user;
  }

  void signOut(){
     Navigator.of(context).push(MaterialPageRoute(
      builder:(BuildContext context){
        return Scaffold(
          //backgroundColor: Colors.white70,
          //backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.purpleAccent[100],
            child: Center(
              //color: Colors.green,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: null,
                    //value: 1,
                    //semanticsLabel: "please wait while uploading",
                  ),
                  Text("please wait while signing out"),
                ],
              ),
            ),
          ),
        );
      }
    ));
    _googleSignIn.signOut();
    Navigator.of(context).pop();
    print("user sign out");
    setState((){
      HomePage.signedIn=false;
      HomePage.user=null;
      _string="succefully sign out";
    });
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
              children: [Column(
          children: <Widget>[
            //Text(_string,textAlign: TextAlign.center,),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(_string,
              style: TextStyle(
                fontSize: 18
              )
              ,textAlign: TextAlign.center,)
            ),
            Container(
              height: 400,
              //width: 320,
              child: HomePage.user != null?
              CircleAvatar(
                minRadius: 80,
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 290,
                    height: 290,
                    child: Image.network(
                      HomePage.user.photoUrl),
                  ),
                )):
              Image.asset("assets/signInPage.jpg"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                HomePage.signedIn == false?
                IconButton(
                  icon: Icon(Icons.email),
                  iconSize: 40,
                  onPressed: _signIn,
                ):
                IconButton(
                  icon: Icon(Icons.dock),
                  iconSize: 40,
                  onPressed: signOut,
                )
              ],
            )
          ],),
              ])
    );
  }
}