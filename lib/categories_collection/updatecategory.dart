import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateCategory extends StatefulWidget {
  final String categogryId ;
  final String oldName ;
  const UpdateCategory({super.key, required this.categogryId, required this.oldName, });

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> with SingleTickerProviderStateMixin {

  GlobalKey<FormState> updatekey = GlobalKey();
  TextEditingController controlCategory = TextEditingController();


  //Add Category
  CollectionReference categories = FirebaseFirestore.instance.collection("categories");

  updateCategory() async{
    try{
      if(updatekey.currentState!.validate()){
        await categories.doc(widget.categogryId).set(
            {'name' : controlCategory.text, }
            ,SetOptions(merge: true));

        Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
      }

    }catch(e){
      print("Error ${e}");
    }
  }

  @override
  void initState() {
    controlCategory.text = widget.oldName ;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controlCategory.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Category"),
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
                    controller: controlCategory,
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
                  updateCategory();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
