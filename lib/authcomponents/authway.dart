import 'package:flutter/material.dart';

class AuthWay extends StatelessWidget {
  final String image ;
  const AuthWay ({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("${image}",width: 25,height: 25,),
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 13),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20)
      ),
    );
  }
}
