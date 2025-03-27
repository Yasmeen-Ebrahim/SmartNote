import 'package:flutter/material.dart';

class Backgroung extends StatefulWidget {
  final String interactbacktitle ;
  final String interactbackbody ;
  const Backgroung({super.key, required this.interactbacktitle, required this.interactbackbody});

  @override
  State<Backgroung> createState() => _BackgroungState();
}

class _BackgroungState extends State<Backgroung> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BackgroundState Page"),),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(widget.interactbacktitle,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              Container(height: 15,),
              Text(widget.interactbackbody,style: TextStyle(fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}
