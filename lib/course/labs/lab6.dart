import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';

class SnackBarDemo extends StatelessWidget {
  const SnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnackBar 教學示範')),
      body: VStack(
        children: [
          // 1. 基礎 SnackBar
          DemoBlock(
            number: 1,
            title: '基礎 SnackBar',
            children: [
              Text(
                '最基本用法：建立 SnackBar 後用 ScaffoldMessenger 顯示。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(content: const Text('這是一個 SnackBar！'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('顯示 SnackBar'),
              ),
            ],
          ),

          // 2. 含動作（Undo）的 SnackBar
          DemoBlock(
            number: 2,
            title: '含動作的 SnackBar（SnackBarAction）',
            gap: 8,
            children: [
              Text(
                '常見於刪除後提供「撤銷」；使用 SnackBarAction。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: const Text('這是一個含動作的 SnackBar！'),
                    action: SnackBarAction(
                      label: '撤銷',
                      onPressed: () {
                        // 執行撤銷操作
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('顯示 SnackBar'),
              ),
            ],
          ),

          // 3. 客製樣式（浮動、圓角、邊距、顏色）
          DemoBlock(
            number: 3,
            title: '客製樣式（浮動、圓角、邊距、顏色）',
            gap: 8,
            children: [
              Text(
                '使用 behavior: floating、margin、shape、backgroundColor 進行風格化。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: const Text('這是客製樣式的 SnackBar！'),
                    backgroundColor: Colors.teal,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text('顯示客製 SnackBar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
