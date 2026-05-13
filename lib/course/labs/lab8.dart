// lab8: 用 Container 做出一個可重用的 Box（給下一章 Row 排列使用）
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../demo_block.dart';
import '../vstack.dart';

// ─── Preview ───
@Preview(name: 'LabelBox Preview')
Widget labelBoxPreview() => const LabelBox(label: 'A', color: Colors.blue);

// ─── 可重用的色塊 Widget（供 lab9 使用）───
class LabelBox extends StatelessWidget {
  const LabelBox({
    super.key,
    required this.label,
    this.color = Colors.blue,
    this.width = 60, //
    this.height = 60,
    this.borderRadius = 8,
  });

  // 同學問this是什麼？
  // 在 Dart 的建構子中，當你使用 this.變數名稱 時，表示你正在將建構子參數賦值給類別的成員變數。
  // 例如，在 LabelBox 類別中，我們有一個成員變數 label，當我們在建構子中寫 this.label 時，表示我們將建構子接收到的 label 參數賦值給類別的 label 變數。
  // 這樣做的好處是可以讓我們在創建 LabelBox 實例時，直接傳入 label、color、width、height 等參數，而不需要在建構子內部再寫一行賦值的程式碼，讓程式碼更簡潔易讀。

  final String label;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

// ─── 教學頁面 ───
class ContainerBoxDemo extends StatelessWidget {
  const ContainerBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container 做 Box')),
      body: VStack(
        children: [
          // 1. 最簡單的 Container
          DemoBlock(
            number: 1,
            title: '最簡單的 Container',
            children: [
              Text(
                '設定 width、height、color 就能做出一個色塊。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                color: Colors.blue,
              ),
            ],
          ),

          // 2. 加上圓角與文字
          DemoBlock(
            number: 2,
            title: '加上圓角與文字',
            children: [
              Text(
                '使用 decoration 設定圓角，用 alignment + child 放入文字。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          // 3. 不同大小與顏色
          DemoBlock(
            number: 3,
            title: '不同大小與顏色',
            children: [
              Text(
                '改變 width、height、color 就能做出各種色塊。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('小',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('中',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text('大',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),

          // 4. 提取成可重用的 Widget（LabelBox）
          DemoBlock(
            number: 4,
            title: '提取成可重用的 LabelBox',
            children: [
              Text(
                '把重複的 Container 程式碼提取成 LabelBox Widget，\n之後只要傳入 label 和 color 即可。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LabelBox(label: 'A', color: Colors.red),
                  LabelBox(label: 'B', color: Colors.green),
                  LabelBox(label: 'C', color: Colors.blue),
                ],
              ),
            ],
          ),

          // 5. 下一章預告
          DemoBlock(
            number: 5,
            title: '下一章：用 Row 排列這些 Box',
            children: [
              Text(
                '學會做出 Box 之後，下一章會把它們放進 Row，\n練習各種對齊與空間分配方式。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 70),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 40),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

