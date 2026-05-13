import 'package:flutter/material.dart';



class StackDemo extends StatelessWidget {
  const StackDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack 基本範例')),
      body: Center(
        child: Stack(
          alignment: Alignment.center, // 預設將子元件置中
          children: [
            // 底層矩形
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // 中層圓形（受 alignment 影響，置中對齊）
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                shape: BoxShape.circle,
              ),
            ),
            // 左上角文字（使用 Positioned 絕對定位，不受 alignment 影響）
            const Positioned(
              top: 16,
              left: 16,
              child: Text(
                'Hello',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // 右下角絕對定位的圖示（不受 alignment 影響）
            const Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                Icons.star,
                size: 48,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}