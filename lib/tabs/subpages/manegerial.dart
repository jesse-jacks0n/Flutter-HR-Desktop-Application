import 'package:flutter/material.dart';

class Manegerial extends StatefulWidget {
  const Manegerial({super.key});

  @override
  State<Manegerial> createState() => _ManegerialState();
}

class _ManegerialState extends State<Manegerial> {
  @override
  Widget build(BuildContext context) {
    const bodyBack = Color(0xFFF6F6F6);
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    final tabBack = Color(0xFF354A48);
    final txtColor2 = Color(0xFFDEDEDE);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:mainColor ,
      ),
      body: Center(
        child: Text("manegerial page"),
      ),
    );
  }
}
