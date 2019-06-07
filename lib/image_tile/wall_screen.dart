
import 'package:camera_app/hompage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'firebase_admob.dart';
//import 'packagefirebase_analytics/firebase_analytics.dart';
//import 'packagefirebase_analytics/observer.dart';

const String testDevice = '';

class WallScreen extends StatefulWidget {
  //final FirebaseAnalytics analytics;
  //final FirebaseAnalyticsObserver observer;

  //WallScreen();

  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
//   FirebaseFirestore firestore = FirebaseFirestore.getInstance();
//  FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
//      .setTimestampsInSnapshotsEnabled(true)
//      .build();
//  firestore.setFirestoreSettings(settings);
  final CollectionReference collectionReference =
      Firestore.instance.collection("image");
  //AssetImage indicator;
 

 /* Future<Null> _currentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName 'Wall Screen', screenClassOverride 'WallScreen');
  }
  */

  
  @override
  void initState() {
    // TODO implement initState
    super.initState();
    subscription = collectionReference.where("user",isEqualTo: HomePage.user.displayName).snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    subscription?.cancel();

    // _currentScreen();
  }
  @override
  void didUpdateWidget(WallScreen oldWidget) {
    // TODO implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    subscription = collectionReference.where("user",isEqualTo: HomePage.user.displayName).snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  
  // void deleteImage(String imgPath){
  //   setState(() {
  //    indicator=AssetImage("assets/loading2.gif");
  //   });
  //   DocumentReference postRef=null;
  //    Firestore.instance
  //   .collection('image')
  //   .where("url", isEqualTo: imgPath)
  //   .getDocuments().then((data){
  //     data.documents.forEach((doc) {
  //     postRef = Firestore.instance.collection("image").document(doc.documentID);
  //     Firestore.instance.runTransaction((Transaction tx) async{
  //       DocumentSnapshot postSnapshot = await tx.get(postRef);
  //       if (postSnapshot.exists) {
  //           tx.delete(postSnapshot.reference).whenComplete(()async {
  //             final StorageReference storageRef = FirebaseStorage.instance.ref().child(postSnapshot.data["name"]);
  //             await storageRef.delete();
  //             print("deleted from storage");
  //             setState(() {
  //              indicator=null;
  //             });
  //             print("succesfully deleted from firebase");
  //            // Navigator.of(context).pop();
  //           });
           
  //       }
  //     });
  //   });
  //   });
    
    
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.blueGrey,
      child:new Scaffold(
          // appBar new AppBar(
          //   title new Text("Wallfy"),
          // ),
          //backgroundColor Colors.lightGreenAccent[300],
          body:wallpapersList != null? new StaggeredGridView.countBuilder(
                  padding:const EdgeInsets.all(8.0),
                  crossAxisCount:4,
                  itemCount:wallpapersList.length,
                  itemBuilder:(context, i) {
                    String imgPath = wallpapersList[i].data['url'];
                    return new Material(
                      elevation:8.0,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                      child: new InkWell(
                        //onLongPress: (){deleteImage(imgPath);},
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new FullScreenImagePage(imgPath)));
                        },
                        child: new Hero(
                          tag: imgPath,
                          child: new FadeInImage(
                            //image: indicator==null?new NetworkImage(imgPath):indicator,
                            image: new NetworkImage(imgPath),
                            fit: BoxFit.cover,
                            placeholder: new AssetImage("assets/loading.gif"),
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (i) =>
                      new StaggeredTile.count(2, i.isEven ? 2 : 3),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ):
               new Center(
                  child: new CircularProgressIndicator(),
                )),
    );
  }
}
