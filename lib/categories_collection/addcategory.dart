import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> with SingleTickerProviderStateMixin {

  GlobalKey<FormState> addkey = GlobalKey();
  TextEditingController controlCategory = TextEditingController();


  //Add Category
  CollectionReference categories = FirebaseFirestore.instance.collection("categories");
  addCategory() async{
    if(addkey.currentState!.validate()){
      try{
        DocumentReference response = await categories.add(
            {
              'name' : controlCategory.text,
              'id' : FirebaseAuth.instance.currentUser!.uid
            },
        );
        Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route)=> false);
      }catch(e){
        print("Error ${e}");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controlCategory.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: ListView(
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
                child: Text("Add",style: TextStyle(color: Colors.white,),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                padding: EdgeInsets.symmetric(horizontal: 18,vertical: 13),
                onPressed: (){
                  addCategory();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
