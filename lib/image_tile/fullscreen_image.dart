import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart';

class FullScreenImagePage extends StatefulWidget {
  String imgPath;
  FullScreenImagePage(this.imgPath);

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  //CircularProgressIndicator indicator;
  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [new Color(0x10000000), new Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  void delete(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder:(BuildContext context){
        return Scaffold(
          //backgroundColor: Colors.white70,
          //backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.blueAccent[100],
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
                  Text("please wait while deleting"),
                ],
              ),
            ),
          ),
        );
      }
    ));
    DocumentReference postRef;
     Firestore.instance
    .collection('image')
    .where("url", isEqualTo: this.widget.imgPath)
    .getDocuments().then((data){
      data.documents.forEach((doc) {
      postRef = Firestore.instance.collection("image").document(doc.documentID);
      postRef.get().then((datasnapshot){
        if(datasnapshot.exists){
          String storeEntry=datasnapshot.data["name"];
          final StorageReference storageRef = FirebaseStorage.instance.ref().child(storeEntry);
          storageRef.delete().whenComplete((){
          print("deleted from storage");
          postRef.delete().whenComplete((){
          print("deleted sucefully from firebase");
          Navigator.of(context).pop();
          Navigator.of(context).pop();
            }).catchError((e)=>{print(e)});
          });
        }else{
          print("document does not exisist");
        }
      });
      
    
      // Firestore.instance.runTransaction((Transaction tx){
      //    tx.get(postRef).then((DocumentSnapshot postSnapshot){
      //      if (postSnapshot.exists) {
      //       tx.delete(postSnapshot.reference).whenComplete(() {
      //         final StorageReference storageRef = FirebaseStorage.instance.ref().child(postSnapshot.data["name"]);
      //         storageRef.delete().then((void a){
      //            print("deleted from storage");
      //         // setState(() {
      //         //  indicator=null;
      //         // });
      //         print("succesfully deleted from firebase");
      //         Navigator.of(context).pop();
      //         Navigator.of(context).pop();
      //       }).catchError((e){print(e);});
      //       });  
      //   }
      //    });  
      // });


    });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(gradient: backgroundGradient),
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child: new Hero(
                  tag: widget.imgPath,
                  child: new Image.network(widget.imgPath),
                ),
              ),
              //indicator==null?Text("click on delete button"):indicator,
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                      icon:Icon(Icons.delete),
                      iconSize: 40,
                      onPressed: ()=>delete(context),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
