import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filtring extends StatefulWidget {
  const Filtring({super.key});

  @override
  State<Filtring> createState() => _FiltringState();
}

class _FiltringState extends State<Filtring> with SingleTickerProviderStateMixin {


  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: usersStream ,
          builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              print("Error");
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Text("loading");
            }
            if(snapshot.connectionState == ConnectionState.done){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  InkWell(
                    onTap: (){
                      DocumentReference documentReference = FirebaseFirestore.instance.
                      collection("users").
                      doc(snapshot.data!.docs[index].id);


                      FirebaseFirestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot =  await transaction.get(documentReference);

                        if(snapshot.exists){
                          var documentData = snapshot.data();

                          if(documentData is Map < String, dynamic>){

                            int newValue =  documentData['money'] + 100 ;

                            transaction.update(documentReference, {'money' : newValue});

                          }
                        }

                      });
                    },
                    child: Card(
                      child: ListTile(
                          title: Text("${snapshot.data!.docs[index]['username']}",style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text("age : ${snapshot.data!.docs[index]['age']}",style: TextStyle(fontSize: 13),),
                          trailing: Text("${snapshot.data!.docs[index]['money']}\$ ",style: TextStyle(color: Colors.blue[700],fontSize: 17,fontWeight: FontWeight.bold),)
                      ),
                    ),
                  );
                },
              );
            }
            return Text("");
          },

        ),
      )
    );
  }
}


