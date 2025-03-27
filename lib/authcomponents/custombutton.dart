import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text ;
  const CustomButton({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        padding: EdgeInsets.all(15),
        child: Text("${text}",style: TextStyle(color: Colors.white),),
        color: Colors.blue,
        onPressed: (){},
      ),
    );
  }
}
