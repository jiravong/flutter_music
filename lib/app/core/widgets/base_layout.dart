// lib/app/core/widgets/base_scaffold.dart
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool safeArea;

  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      body: GestureDetector(
        // ทำให้กดที่ว่างแล้วคีย์บอร์ดปิดอัตโนมัติ (UX ที่ดี)
        onTap: () => FocusScope.of(context).unfocus(),
        child: safeArea ? SafeArea(child: body) : body,
      ),
    );
  }
}