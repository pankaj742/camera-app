import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseEdit extends StatefulWidget {
  @override
  _DatabaseEditState createState() => _DatabaseEditState();
}

class _DatabaseEditState extends State<DatabaseEdit> {
  final CollectionReference collectionReference=Firestore.instance.collection("image");
  var _text='hello';
  File _image;
  Image url_image;//Image.asset("assets/download.jpg");
  String _url="https://firebasestorage.googleapis.com/v0/b/camera-app-ecf92.appspot.com/o/2019-04-08%2016%3A18%3A22.136879?alt=media&token=ee954230-4f33-4909-af7c-5c204c2401cf";
  String last_entry;
  String last_store_name;
  bool captured=false;

 Future<void> _add() async{
    DateTime now = DateTime.now();
    String formattedDate = now.toString();
    final StorageReference storageRef = FirebaseStorage.instance.ref().child(formattedDate);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(_image.path),
      StorageMetadata(
        contentType: 'image'+'/'+'jpg',
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');
    //Map<String,String> data={_image.toString():url};
    collectionReference.add({"url":url,"name":formattedDate}).then((DocumentReference id){
      setState((){
       // _url=null;
       _text="added succefully";
       _image=null; 
       last_entry=id.documentID;
       captured=false;
      });
      print("document added succefully");
    }).catchError((e)=>{print(e)});
  }
  // void _update(doc_name,data){
  //   DocumentReference document=collectionReference.document(doc_name);
    
  //   document.setData(data).whenComplete((){
  //     setState(() {
  //      _text="updated sucefully"; 
  //     });
  //     print("data updated sucefully");
  //   });
  // }
  void _delete(){
    final StorageReference storageRef = FirebaseStorage.instance.ref().child(last_store_name);
    storageRef.delete().whenComplete(()=>{
      print("deleted from storage")
    });
    collectionReference.document(last_entry).delete().whenComplete(()=>{
      print("deleted sucefully from firebase")
    }).catchError((e)=>{print(e)});
    setState(() {
     captured=false;
     _image=null;
     _text="deleted sucefully"; 
    });
  }
  Future<void> _fetch() async{
    print(last_entry);
    DocumentReference document=collectionReference.document(last_entry);
    document.get().then((datasnapshot){
      print("checking condition");
      if(datasnapshot.exists){
        String url=datasnapshot.data["url"];
        String store_name=datasnapshot.data["name"];
        // Image temp= Image.network(url);
        // print("image loaded");
        setState(() {
           _url=url;
           last_store_name=store_name;
           captured=false;
        }
        );
       print("document does not exist");
      }
    });
  }
  Future<void> _getImage() async{
      File res=await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        if(res != null){
          _image=res;
          captured=true;
        }
      });
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
              children: [
                Text(_text),
                //Padding(padding: EdgeInsets.all(100),),
                ((_image == null) && (captured == true))?Image.asset("assets/download.jpg"):(captured==true?Image.file(_image):Image.network(_url)),
                Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.publish),
              onPressed: _add,
            ),
            IconButton(
              icon: Icon(Icons.update),
              onPressed: null//_update,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _delete,
            ),
            IconButton(
              icon: Icon(Icons.get_app),
              onPressed: _fetch,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed:_getImage,
            ),
          ],
        ),]
      ),
    );
  }
}