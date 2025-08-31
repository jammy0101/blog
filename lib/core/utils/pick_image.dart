
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage()async{
  try{

    final xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      imageQuality: 50,
    );

    if(xFile != null){
      return File(xFile.path);
    }
    return null;
  }catch(e){
    return null;
  }
}

// Future<File?> pickImage(ImageSource source) async {
//   try {
//     final xFile = await ImagePicker().pickImage(source: source);
//     return xFile != null ? File(xFile.path) : null;
//   } catch (e) {
//     return null;
//   }
// }
