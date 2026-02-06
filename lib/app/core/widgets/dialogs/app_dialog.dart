// lib/app/core/widgets/dialogs/app_dialogs.dart
import 'package:flutter_music_clean_getx/app/core/themes/app_colors.dart';
import 'package:flutter_music_clean_getx/app/core/themes/app_text_style.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  // ฟังก์ชันแสดง Modal ยืนยัน
  static Future<void> showConfirm({
    required String title,
    required String description,
    required VoidCallback onConfirm,
  }) {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyle.text2xlBold),
            const SizedBox(height: 10),
            Text(description, style: AppTextStyle.textMdRegular),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('ยกเลิก', style: AppTextStyle.textMdRegular),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () {
                      Get.back(); // ปิด Modal
                      onConfirm(); // ทำคำสั่งที่ส่งมา
                    },
                    child: Text('ตกลง', style: AppTextStyle.textMdRegular.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// how to use
// ใน Controller
// void onDeleteAccount() {
//   AppDialogs.showConfirm(
//     title: 'ยืนยันการลบ',
//     description: 'คุณแน่ใจใช่ไหมที่จะลบรายการนี้?',
//     onConfirm: () {
//       // Logic การลบข้อมูลตรงนี้
//       print('Deleted!');
//     },
//   );
// }