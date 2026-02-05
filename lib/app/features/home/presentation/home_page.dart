import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // แสดงผลหน้าตาม Index ที่เลือก
      body: Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}