import 'package:flutter/material.dart';

class TestBg extends StatefulWidget {
  const TestBg({super.key});

  @override
  State<TestBg> createState() => _TestBgState();
}

class _TestBgState extends State<TestBg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Use double.infinity for full width
        height: double.infinity, // Use double.infinity for full height
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: double.infinity, // Use double.infinity for full width
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('image/BG.png'), // Use relative path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top:330,
              child: Container(
              width: MediaQuery.of(context).size.width,
              height: 600,
              decoration: const BoxDecoration(
                color:Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40))),
                // ignore: prefer_const_constructors
                child: Column(children: [
                  
                ],),
            ))
          ],
        ),
      ),
    );
  }
}
