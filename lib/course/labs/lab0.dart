// 介紹 SizedBox 的各種用法
import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';

class SizedBoxDemo extends StatelessWidget {
  const SizedBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SizedBox 教學範例')),
      body: Column(
            children: [
              // 場景 1：作為「間距」使用
              const Text('這是一段文字'),
              const SizedBox(height: 20), // 垂直間距 20 像素
              const Text('這段文字與上面隔了 20 像素'),

              const SizedBox(height: 40),

              // 場景 2：用來「限制子組件尺寸」
              const Text('固定尺寸的按鈕（200 x 50）：'),
              const SizedBox(height: 10),
              SizedBox(
                width: 200, // 固定寬度 200
                height: 50, // 固定高度 50
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('我是固定大小'),
                ),
              ),

              const SizedBox(height: 20),

              // 場景 2-2：用 double.infinity 讓按鈕撐滿寬度
              const Text('撐滿寬度的按鈕（double.infinity）：'),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // 寬度填滿父容器
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('我撐滿了整行'),
                ),
              ),

              const SizedBox(height: 40),

              // 場景 3：在水平佈局中使用
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 10), // 水平間距 10 像素
                  Text('星星與文字之間有間距'),
                ],
              ),
            ],
          ),
    );
  }
}