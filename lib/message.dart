
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  static String user;
  Message(String _user){
    user=_user;
  }
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  double inputPosition=420.0;
  final myController = TextEditingController();
  FocusNode myFocusNode;
  CollectionReference collectionReference=Firestore.instance.collection("messages");
  List<Map<dynamic,dynamic>> messageList;
  StreamSubscription<QuerySnapshot> subscription;
  int _index=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.where("user",isEqualTo:Message.user).snapshots().listen((datasnapshot) {
      List<DocumentSnapshot>docs = datasnapshot.documents;
      // print(docs[0].data["conversation"]);
      List<Map<dynamic,dynamic>> conv;
      if(docs !=null){
         conv= (docs[0].data["conversation"]).cast<Map<dynamic,dynamic>>();
      }
      print("conversation"+conv.toString());
      setState(() {
        messageList = conv;
      });
    });
    myController.addListener(_getText);
    myFocusNode = FocusNode();
  }

  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    myFocusNode.dispose();
    myController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  _getText(){
     print(myController.text);
  //   setState(() {
  //       // inputPosition=250.0;
       
  // });
  }
  sendMessage(){
    collectionReference.where("user",isEqualTo:Message.user).getDocuments().then(
        (queryShot){
          print(queryShot.documents);
            // print(queryShot.documents[0]);
            DocumentSnapshot doc;
            if(queryShot.documents.length !=0){
                doc=queryShot.documents[0];
            }
            if(doc == null){
                var data={
                    "user": Message.user,
                    "conversation":new List()
                };
                data["conversation"]=[{
                    "role": "seller",
                    "message": myController.text
                }];
                print(data);
                collectionReference.add(data).then((doc){
                    print("document added new user "+doc.documentID);
                    setState(() {
                      myController.clear();
                      myFocusNode.unfocus();
                      inputPosition=420.0;
                      _index=0;
                    });
                    // alert("please click on send button again");
                    return;
                });
               
            }
            List<Map<dynamic,dynamic>> msg=List.from(doc.data["conversation"].cast<Map<dynamic,dynamic>>());
            msg.add({
                "role":"seller",
                "message":myController.text
            });
            collectionReference.document(doc.documentID).updateData({
                "conversation":msg
            })
            .whenComplete((){
                print("Document successfully updated!");
                 setState(() {
                  myController.clear();
                  myFocusNode.unfocus();
                  inputPosition=420.0;
                  _index=0;
                });
            })
            .catchError((error) {
                // The document probably doesn't exist.
                print("Error updating document: "+ error);
            });
        }
    );

    // collectionReference.add({
    //   "role": "seller",
    //   "message":myController.text,
    //   "user":Message.user,
    //   "conver"
    // });
    // print("message sent");
    // setState(() {
    //   myController.clear();
    //   myFocusNode.unfocus();
    //   inputPosition=420.0;
    //   _index=0;
    // });
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: IndexedStack(
        index: _index,
        children: <Widget>[
          ListView(
                children: [Container(
              // width: 400,
              height: 600,
              color: Colors.green[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Container(
                      width: 300,
                      height: 450,
                      // color: Colors.white,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: messageList != null && messageList.length >0?ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (context,i){
                          
                          String role=messageList[i]["role"];
                          print(role);
                          if( role == "seller"){
                             return  Container(
                              margin: EdgeInsets.fromLTRB(100, 2, 8, 2),
                              // width: 20,
                              // height: 50,
                              constraints: BoxConstraints(minHeight: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.teal[100],
                                border: Border(
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black)
                                )
                              ),
                              child: Text(messageList[i]["message"],
                              textAlign: TextAlign.center,
                              ),
                            );
                          }else{
                            return  Container(
                              margin: EdgeInsets.fromLTRB(8, 2, 100, 2),
                              // width: 20,
                              // height: 50,
                              constraints: BoxConstraints(minHeight: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.lightGreenAccent[100],
                                border: Border(
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black)
                                )
                              ),
                              child: Text(messageList[i]["message"],
                              textAlign: TextAlign.center,
                              ),
                            );
                          }
                         
                        },
                      ):null,
                    ),
                  ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: IconButton(
             icon: Icon(Icons.message),
             iconSize: 60,
             onPressed: (){
               setState(() {
                _index=1; 
               });
             },
             ),
                   ),
                ],
              ),
            ),
          
                 ] ),
         ListView(
           children: <Widget>[
             IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 50,
                              alignment: Alignment.topLeft,
                              onPressed: (){
                                setState(() {
                                 _index=0; 
                                });
                              },
                            ),
             Padding(
               padding: EdgeInsets.fromLTRB(0, 0, 0,0),
                child: Container(
                  color: Colors.transparent,
                  width: 200,
                  // height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, inputPosition, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                        ),
                        child: Row(
                          children: <Widget>[
                            
                            Padding(
                                    padding: EdgeInsets.fromLTRB(5, 20, 0, 30),
                                     child: Container(
                                       width: 270,
                                       
                                       child: TextField(
                                         controller: myController,
                                         autofocus: false,
                                         maxLines: 1,
                                         onTap:(){
                                           setState(() {
                                             inputPosition=180.0;
                                           });
                                         },
                                         focusNode: myFocusNode,
                                         onEditingComplete: (){
                                           setState(() {
                                            inputPosition=420.0;
                                            myFocusNode.unfocus();
                                     
                                           });
                                         },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          )
                                        ),
                                      ),
                                    ),
                            ),
                            FloatingActionButton(
                              child: Icon(Icons.send),
                              onPressed: sendMessage,
                            ),
                          ],
                        ),
                        // child: FloatingActionButton(
                        //   child: Icon(Icons.send,size: 40,),
                          
                        // ),
                    ),
                  )
                  ,
                ),
                      ),
                      // Text("hi")
           ],
         ) 
        ],
      ),
    );
  }
}