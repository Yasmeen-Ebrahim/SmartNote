import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/notes_subcollection/addnote.dart';
import 'package:fluttercourse/notes_subcollection/updatenote.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../categories_collection/updatecategory.dart';

class NotesPage extends StatefulWidget{
  final String categoryId ;

  const NotesPage({super.key, required this.categoryId,}) ;

  State<NotesPage> createState () => _NotesPageState() ;

}
class _NotesPageState extends State<NotesPage> {

  //Get note data
  List listnote = [];
  bool loading = true ;


  getnotes() async{
    QuerySnapshot notes =  await FirebaseFirestore.instance.collection("categories").doc(widget.categoryId).collection("note").get();
    await Future.delayed(Duration(seconds: 1));
    loading = false ;
    listnote.addAll(notes.docs);
    setState(() {

    });


  }

  @override
  void initState() {
   getnotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> AddNote(categoryId: '${widget.categoryId}',)));
        },
      ),
      appBar: AppBar(
        title: Text("Notes Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async{
              // GoogleSignIn signingoole = GoogleSignIn();
              // signingoole.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("Signin");
            },
          )
        ],
      ),
      body: loading == true ? Center(child: CircularProgressIndicator(color: Colors.blue[700],),) : GridView.builder(
        itemCount: listnote.length,
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> UpdateNote(
                categoryId: '${widget.categoryId}',
                oldName: '${listnote[index]['note']}',
                noteId: '${listnote[index].id}',
              )));
            },
            onLongPress: () async{
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'DELETE',
                titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                desc: 'are you sure you want to delete this item ?',
                btnOkOnPress: () async{
                  await FirebaseFirestore.instance.collection("categories")
                      .doc(widget.categoryId)
                      .collection("note")
                      .doc("${listnote[index].id}")
                      .delete();

                  if(listnote[index]['url'] != "none"){
                    FirebaseStorage.instance.refFromURL(listnote[index]['url']).delete();
                  }
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NotesPage(categoryId: "${widget.categoryId}")),);
                },
                btnCancelOnPress: (){

                }
              ).show();
            },
            child: Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("${listnote[index]['note']}",style: TextStyle(fontWeight: FontWeight.bold),),
                      Container(height: 10,),
                      if(listnote[index]['url'] != "none")
                        Image.network(listnote[index]['url'],height: 80,)
                    ],
                  ),
                )),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 5),

      ),
    );
  }

}


