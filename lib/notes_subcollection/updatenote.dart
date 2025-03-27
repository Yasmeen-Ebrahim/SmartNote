import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/notes_subcollection/view.dart';

class UpdateNote extends StatefulWidget {
  final String categoryId ;
  final String oldName ;
  final String noteId ;
  const UpdateNote({super.key, required this.categoryId, required this.oldName, required this.noteId, });

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> with SingleTickerProviderStateMixin {

  GlobalKey<FormState> updatekey = GlobalKey();
  TextEditingController controlNote = TextEditingController();


 updatenote() async{
   try{
     if(updatekey.currentState!.validate()){
       await FirebaseFirestore.instance.collection("categories").
       doc(widget.categoryId).
       collection("note").
       doc(widget.noteId).update({
         'note' : controlNote.text
       });
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> NotesPage( categoryId: '${widget.categoryId}',)));
     }
   }catch(e){
     print(e);
   }
 }

 @override
  void initState() {
    controlNote.text = widget.oldName ;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controlNote.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Note"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(height: 20,),
              Form(
                key: updatekey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return "Can,t To Be Empty" ;
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
                child: Text("Save",style: TextStyle(color: Colors.white,),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                onPressed: (){
                  updatenote();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
