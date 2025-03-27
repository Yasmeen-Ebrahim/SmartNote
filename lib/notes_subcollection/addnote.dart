import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:fluttercourse/notes_subcollection/view.dart';

class AddNote extends StatefulWidget {
  final String categoryId ;
  const AddNote({super.key,required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {

  GlobalKey<FormState> addkey = GlobalKey();
  TextEditingController controlNote = TextEditingController();

  File? imageFile ;
  String? url ;

  //add note
  addnote(context) async{
    try{
      if(addkey.currentState!.validate()){
        await FirebaseFirestore.instance.collection("categories").doc(widget.categoryId).collection("note").add(
            {
              'note' : controlNote.text,
              'url' : url ?? "none"
            }
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> NotesPage(categoryId: "${widget.categoryId}",)));
      };
    }catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controlNote.dispose();
  }


  uploadFile() async{

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);

    final storageRef = FirebaseStorage.instance.ref("images/").child(basename(imageFile!.path));
    await storageRef.putFile(imageFile!);
    url =  await storageRef.getDownloadURL();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body:  ListView(
        children: [
          Column(
            children: [
              Container(height: 20,),
              Form(
                key: addkey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Can't To Be Empty" ;
                      }
                    },
                    keyboardType: TextInputType.name,
                    controller: controlNote,
                    cursorColor: Colors.blue[700],
                    decoration: InputDecoration(
                        hintText: "Enter name",
                        hintStyle: TextStyle(color: Colors.grey[500],fontSize: 14),
                        contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(70),
                            //borderSide: BorderSide(color: Colors.blue.shade400)
                            borderSide: BorderSide(color: Colors.grey.shade400)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(70),
                            borderSide: BorderSide(color: Colors.blue.shade700)
                        )
                    ),
                  ),
                ),
              ),
              Container(height: 40,),
              MaterialButton(
                color: Colors.blue[700],
                child: Text("Upload Image",style: TextStyle(color: Colors.white,),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                onPressed: (){
                  uploadFile();
                },
              ),
              Container(height: 20,),
              MaterialButton(
                color: Colors.blue[700],
                child: Text("Add",style: TextStyle(color: Colors.white,),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                onPressed: (){
                  addnote(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
