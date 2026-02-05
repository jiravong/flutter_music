import 'package:flutter/material.dart';

import '../../music_list/presentation/music_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. กำหนดค่า Index เริ่มต้น
  int _selectedIndex = 0;

  // 2. รายการหน้าจอที่จะแสดงผลตามลำดับปุ่ม
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    MusicListPage(),
    Center(child: Text('Explore', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  // 3. ฟังก์ชันเมื่อมีการกดปุ่ม
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // แสดงผลหน้าตาม Index ที่เลือก
      body: _pages[_selectedIndex],
      // ส่วนของ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ใช้แบบ fixed เพื่อให้เห็นสีและข้อความชัดเจนเมื่อมี 4 ปุ่ม
        currentIndex: _selectedIndex,       // บอกว่าตอนนี้อยู่ที่ Index ไหน
        onTap: _onItemTapped,               // เรียกฟังก์ชันเมื่อกดปุ่ม
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}