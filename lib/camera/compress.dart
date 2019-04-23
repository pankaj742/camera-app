import 'dart:io';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:path_provider/path_provider.dart';

class Compress{

  Future<File> compressFile(File file) async{
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Image image = decodeImage(new File(file.path).readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  Image thumbnail = copyResize(image, 320);
   
   //Io.File compressedFile= Io.File("compressed.jpg",);
  // Save the thumbnail as a PNG.
  //compressedFile.writeAsBytesSync(encodeJpg(thumbnail));


  //  getApplicationDocumentsDirectory().then((directory){
  //   Io.File _file = Io.File(directory.path+'/compressed.jpg');
  Directory dir=await getTemporaryDirectory();
   String path= dir.path;
   DateTime now = DateTime.now();
String formattedDate = now.toString();
  File compressed=File(path+"/"+formattedDate+".jpg");
  
    compressed.writeAsBytesSync(encodeJpg(thumbnail));
  print("image compressed");
  return compressed;
  //return compressedFile;

  //return _file;
  //});

}

}