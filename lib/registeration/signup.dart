import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authcomponents/custombutton.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool passicon = true ;
  TextEditingController controlemail = TextEditingController();
  TextEditingController controlpass = TextEditingController();
  TextEditingController controlusername = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [
          Column(
            children: [
              Container(height: 40,),
              //logo
              Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(70)
                  ),
                  child: Image.asset("images/notelogo.png",width: 60,height: 60,),
                ),
              ),

              Container(height: 17,),

              //textformfelid
              Form(
                key: formkey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      Container(height: 8,),
                      Text("Enter Your Personal Informatin",style: TextStyle(color: Colors.grey),),
                      Container(height: 20,),


                      //username
                      Text("Username",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      Container(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "it must not be empty" ;
                          }
                        },
                        keyboardType: TextInputType.name,
                        controller: controlusername,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: 14),
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade100)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade300)
                            )
                        ),
                      ),

                      Container(height: 15,),

                      //email
                      Text("Email",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      Container(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "it must not be empty" ;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: controlemail,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: 14),
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade100)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade300)
                            )
                        ),
                      ),

                      Container(height: 15,),

                      //password
                      Text("Password",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      Container(height: 10,),
                      TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "it must not be empty" ;
                          }
                        },
                        controller: controlpass,
                        cursorColor: Colors.blue,
                        obscureText: passicon,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye_outlined,color: Colors.blue[700]),
                              onPressed: () {
                                setState(() {
                                  passicon = !passicon ;
                                });
                              },
                            ),
                            hintText: "Enter password",
                            hintStyle: TextStyle(color: Colors.grey[400],fontSize: 14),
                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade100)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(70),
                                borderSide: BorderSide(color: Colors.blue.shade300)
                            )
                        ),
                      ),

                      Container(height: 15,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(height: 30,),
          //button
          Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
          padding: EdgeInsets.all(15),
          child: Text("Register",style: TextStyle(color: Colors.white),),
          color: Colors.blue[700],
          onPressed: () async{
           if(formkey.currentState!.validate()){
             try {
               final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                 email: controlemail.text,
                 password: controlpass.text,
               );
               FirebaseAuth.instance.currentUser!.sendEmailVerification();
               Navigator.of(context).pushReplacementNamed("Signin");
             } on FirebaseAuthException catch (e) {
               if (e.code == 'weak-password') {
                 showDialog(
                     context: context,
                     builder: (context){
                       return AlertDialog(
                         title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                         content: Text("this password provided is too weak"),
                         actions: [
                           TextButton(child: Text("ok",style: TextStyle(color: Colors.blue[700]),),
                             onPressed: () async {
                               Navigator.of(context).pop();
                             },),
                           TextButton(child: Text("cancel",style: TextStyle(color: Colors.blue[700]),),
                             onPressed: (){
                               Navigator.of(context).pop();
                             },)
                         ],
                       );
                     }
                 );
               } else if (e.code == 'email-already-in-use') {
                 showDialog(
                     context: context,
                     builder: (context){
                       return AlertDialog(
                         title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                         content: Text("this account already exists for that email"),
                         actions: [
                           TextButton(child: Text("ok",style: TextStyle(color: Colors.blue[700]),),
                             onPressed: () async {
                               Navigator.of(context).pop();
                             },),
                           TextButton(child: Text("cancel",style: TextStyle(color: Colors.blue[700]),),
                             onPressed: (){
                               Navigator.of(context).pop();
                             },)
                         ],
                       );
                     }
                 );
               }
             } catch (e) {
               print(e);
             }
           }
          },
    ),
    )
        ],
      )
    );
  }
}
