import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercourse/authcomponents/authway.dart';
import 'package:fluttercourse/authcomponents/custombutton.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninPage extends StatefulWidget{

  const SigninPage({super.key}) ;

  State<SigninPage> createState () => _SigninPageState() ;

}
class _SigninPageState extends State<SigninPage> {

  bool passicon = true ;
  bool isloading = false;
  TextEditingController controlemail = TextEditingController();
  TextEditingController controlpass = TextEditingController();
  GlobalKey<FormState> keyform = GlobalKey() ;


  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // if(googleUser == null){
    //   return ;
    // }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("Homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading == true ? Center(child: CircularProgressIndicator(color: Colors.blue[700]),) :ListView(
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

                Container(height: 20,),

                //textformfelid
                Form(
                  key: keyform,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                        Container(height: 8,),
                        Text("Login to continue using the app",style: TextStyle(color: Colors.grey),),
                        Container(height: 20,),

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

                        Container(height: 20,),

                        //password
                        Text("Password",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                        Container(height: 10,),
                        TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "it must not be empty" ;
                            }
                          },
                          keyboardType: TextInputType.name,
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
                        Container(height: 10,),


                        InkWell(
                          onTap: () async{
                            try{
                              if(controlemail.text == ""){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                                        content: Text("Enter your email, please"),
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
                                return ;
                              }
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: controlemail.text);
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Attention",style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Text("Check your email and change the password"),
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
                            }catch(e){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                                      content: Text("This is wrong email, please enter the right one"),
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
                          },
                          child: Container(
                              alignment: Alignment.bottomRight,
                              child: Text("Forget Password?",style: TextStyle(fontSize: 14,),)
                          ),
                        )
                      ],

                    ),
                  ),
                ),
              ],
            ),
            Container(height: 20,),

            //button
            Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
            padding: EdgeInsets.all(15),
            child: Text("Login",style: TextStyle(color: Colors.white),),
            color: Colors.blue[700],
            onPressed: () async{
              if(keyform.currentState!.validate()){
                try {
                  isloading = false ;
                  setState(() {

                  });
                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: controlemail.text,
                      password: controlpass.text
                  );
                  isloading = true ;
                  setState(() {

                  });
                  if(credential.user!.emailVerified){
                    Navigator.of(context).pushReplacementNamed("Homepage");
                  }else
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                            content: Text("Sign in with your email, please"),
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
                  isloading = false ;
                  setState(() {

                  });

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                            content: Text("No user found for that email"),
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
                  } else if (e.code == 'wrong-password') {
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Error",style: TextStyle(fontWeight: FontWeight.bold),),
                            content: Text("Wrong password provided for that user"),
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
                }
              }

            },
    ),
    ),
            Container(height: 25,),
            Container(
                alignment: Alignment.center,
                child: Text("Or Login With",style: TextStyle(fontSize: 14,),)
            ),
            Container(height: 20,),

            //authways
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset("images/facelogo.png",width: 25,height: 25,),
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 13),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      signInWithGoogle();
                    },
                    child: Container(
                    child: Image.asset("images/googlelogo.png",width: 25,height: 25,),
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 13),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20)
                    ),
                                    ),
                  ),

                  AuthWay(image: "images/applelogo.png")
                ],
              ),
            ),
            Container(height: 25,),


            //register
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                      child: Text("Register",style: TextStyle(color: Colors.blue[700],fontWeight: FontWeight.bold),),
                      onPressed: (){
                        Navigator.of(context).pushNamed("Signup");
                      },
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}


