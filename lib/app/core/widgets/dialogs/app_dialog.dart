import 'package:music_roop/app/core/themes/app_text_style.dart';
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
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.primary),
                    onPressed: () {
                      Get.back(); // ปิด Modal
                      onConfirm(); // ทำคำสั่งที่ส่งมา
                    },
                    child: Text('ตกลง', style: AppTextStyle.textMdRegular.copyWith(color: Get.theme.colorScheme.onPrimary)),
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