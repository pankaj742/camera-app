import 'dart:io';

import 'package:camera_app/camera/compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Image Sender'),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  //Image _loadingImage;
  String _text="please select an image";
Future<void> getImage() async{
      File res=await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        if(res != null){
          _image=res; 
        }
      });
    }
Future<void> getGalaryImage() async{
      File res=await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        if(res != null){
          _image=res; 
        }
      });
    }
Future<void> sendImage()async{
  // setState(() {
  //  _text="uploading image please wait";
  //  _loadingImage=Image.asset("assets/loading3.gif"); 
  // });
  Navigator.of(context).push(MaterialPageRoute(
      builder:(BuildContext context){
        return Scaffold(
          //backgroundColor: Colors.white70,
          //backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.pink[100],
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
                  Text("please wait while uploading"),
                ],
              ),
            ),
          ),
        );
      }
    ));
  final CollectionReference collectionReference=Firestore.instance.collection("image");
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
      
      print("document added succefully");
    }).catchError((e)=>{print(e)});

    Navigator.of(context).pop();
    setState(() {
     _text="image send succesfully";
     _image=null; 
    });
  //   setState(() {
  //  _text="image send sucefully";
  //  _loadingImage=null;
  //  _image=null; 
  // });
}
void compressImage()async{
  // setState(() {
  //   _text="compressing image";
  //   _loadingImage= Image.asset("assets/loading2.gif");
  // });
   Navigator.of(context).push(MaterialPageRoute(
      builder:(BuildContext context){
        return Scaffold(
          //backgroundColor: Colors.white70,
          //backgroundColor: Colors.transparent,
          body: Container(
            color: Colors.green[100],
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
                  Text("please wait while compressing"),
                ],
              ),
            ),
          ),
        );
      }
    ));
  Compress handle=Compress();
    // RandomAccessFile _file
        File compressed=await handle.compressFile(_image);
    Navigator.of(context).pop();
setState(() {
    _image=compressed;
    print(_image.path);print(_image.lengthSync());
    _text="Image compressed sucessfully\nclick on sent to send it";
});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: ListView(
                children: [
                  //_loadingImage==null?Container():_loadingImage,
                  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   'click on the button to have image',
                //   style: Theme.of(context).textTheme.button,
                // ),
                Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: _image == null?Text(_text): Container(
                    color: Colors.transparent,
                    child:Image.file(_image)),
                    //width: 400,
                    height: 470,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.home),
                      iconSize: 40,
                      onPressed: getGalaryImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.camera),
                      iconSize: 40,
                      onPressed: getImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconSize: 40,
                      onPressed: compressImage,
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 40,
                      onPressed: sendImage,
                    )
                  ],
                )
              ],
          ),]
        ),
      ),
      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}