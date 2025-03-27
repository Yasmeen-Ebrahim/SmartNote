import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CloudStorage extends StatefulWidget {
  const CloudStorage({super.key});

  @override
  State<CloudStorage> createState() => _CloudStorageState();
}

class _CloudStorageState extends State<CloudStorage> with SingleTickerProviderStateMixin {

   File? imageFile ;
   String? url ;

  pickImage() async {

    //pick the image & put it in file
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);

    //upload the file
    var storagRef = FirebaseStorage.instance.ref(basename(imageFile!.path));
    storagRef.putFile(imageFile!);
    url = await storagRef.getDownloadURL();

    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image File"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Container(height: 30,),
              Container(
                child: MaterialButton(
                  color: Colors.blue[700],
                  child: Text("Pick Image",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    pickImage();
                  },
                ),
              ),
              Container(height: 20,),
              if(imageFile != null)
                Image.network(url!,height: 300,fit: BoxFit.cover,)
            ],
          ),
        ),
      ),
    );
  }
}
