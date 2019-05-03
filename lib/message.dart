
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  double inputPosition=420.0;
  final myController = TextEditingController();
  FocusNode myFocusNode;
  CollectionReference collectionReference=Firestore.instance.collection("messages");
  List<DocumentSnapshot> messageList;
  StreamSubscription<QuerySnapshot> subscription;
  int _index=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        messageList = datasnapshot.documents;
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
    collectionReference.add({
      "role": "seller",
      "message":myController.text 
    });
    print("message sent");
    setState(() {
      myController.clear();
      myFocusNode.unfocus();
      inputPosition=420.0;
      _index=0;
    });
    
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
                      child: messageList != null?ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (context,i){
                          String role=messageList[i].data["role"];
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
                              child: Text(messageList[i].data["message"],
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
                              child: Text(messageList[i].data["message"],
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