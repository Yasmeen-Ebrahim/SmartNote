import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/notes_subcollection/view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'categories_collection/updatecategory.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key}) ;

  State<HomePage> createState () => _HomePageState() ;

}
class _HomePageState extends State<HomePage> {

  //Get Data
  List <QueryDocumentSnapshot> documents = [];
  bool loading = true ;

  getData() async{
    loading = true ;
    setState(() {

    });
    QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection("categories").where('id' , isEqualTo : FirebaseAuth.instance.currentUser!.uid).get();
    await Future.delayed(Duration(seconds: 1));
    loading = false ;
    documents.addAll(querySnapshot.docs);
    setState(() {

    });
  }

  @override
  void initState() {
    getData();
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
          Navigator.of(context).pushNamed("addcategory");
        },
      ),
      appBar: AppBar(
        title: Text("Home Page"),
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
        itemCount: documents.length,
        itemBuilder: (context,i){
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NotesPage(categoryId: '${documents[i].id}',)));
            },
            onLongPress: (){
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  title: 'CHOOSE',
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  desc: 'you want to delete or update your item ?',
                  btnOkText: "Update",
                  btnOkOnPress: ()async{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdateCategory(categogryId: documents[i].id, oldName: documents[i]['name']), ));
                  },
                  btnCancelText: "Delete",
                  btnCancelOnPress: () async{
                    await FirebaseFirestore.instance.collection("categories").doc(documents[i].id).delete();
                    Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
                  }
              ).show();
            },
            child: Card(
                child: Container(
                   padding: EdgeInsets.all(8),
                   child: Column(
                   children: [
                   Image.asset("images/folder.png",height: 130,),
                   Text("${documents[i]['name']}",style: TextStyle(fontWeight: FontWeight.bold),)
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


