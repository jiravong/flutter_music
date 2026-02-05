import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // แสดงผลหน้าตาม Index ที่เลือก
      body: const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}