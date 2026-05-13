//Button

import 'package:flutter/material.dart';

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button 教學示範')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. ElevatedButton（實心按鈕）
            ElevatedButton(
              onPressed: () {
                // 按鈕被點擊時的行為
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ElevatedButton 被點擊了！')),
                );
              },
              child: const Text('ElevatedButton'),
            ),


            const SizedBox(height: 12),

            // 2. TextButton（文字按鈕）
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TextButton 被點擊了！')),
                );
              },
              child: const Text('TextButton'),
            ),

            const SizedBox(height: 12),

            // 3. OutlinedButton（帶邊框按鈕）
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OutlinedButton 被點擊了！')),
                );
              },
              child: const Text('OutlinedButton'),
            ),


            const SizedBox(height: 12),

            // 4. IconButton（圖示按鈕）
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('IconButton 被點擊了！')),
                );
              },
              icon: const Icon(Icons.thumb_up),
            ),


            const Divider(height: 32),

            // 5. 禁用狀態示範
            ElevatedButton(
              onPressed: null, // onPressed 為 null 表示按鈕被禁用
              child: const Text('Disabled ElevatedButton'),
            ),

            const SizedBox(height: 12),

            // 6. 自訂樣式示範
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 按鈕背景色
                foregroundColor: Colors.white, // 按鈕文字色
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 按鈕內邊距
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 圓角
                ),
              ),
              child: const Text('Custom Styled Button'),
            ),

          ],
        ),
      ),
    );
  }
}