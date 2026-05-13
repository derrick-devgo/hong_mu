// lab7: Container 基礎教學
import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';

class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container 教學範例')),
      body: VStack(
        children: [
          // 1. 基本 Container（寬、高、顏色）
          DemoBlock(
            number: 1,
            title: '基本 Container',
            children: [
              Text(
                '設定 width、height、color 就能做出一個色塊。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: 120,
                height: 80,
                color: Colors.blue,
              ),
            ],
          ),

          // 2. padding（內邊距）
          DemoBlock(
            number: 2,
            title: 'padding（內邊距）',
            children: [
              Text(
                'padding 讓 child 與 Container 邊界之間有間距。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.blue[100],
                padding: const EdgeInsets.all(20),
                child: Container(
                  color: Colors.blue,
                  width: 80,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text('child', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),

          // 3. margin（外邊距）
          DemoBlock(
            number: 3,
            title: 'margin（外邊距）',
            children: [
              Text(
                'margin 讓 Container 與外部元件之間有間距。\n藍色區塊左邊有 40 的 margin。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.grey[200],
                width: double.infinity,
                height: 300,                
                alignment: Alignment.centerLeft,                
                child: Container(
                  margin: const EdgeInsets.only(left: 40),
                  width: 120,
                  height: 60,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text('margin-left: 40',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),

          // 4. alignment
          DemoBlock(
            number: 4,
            title: 'alignment（子元件對齊）',
            children: [
              Text(
                '控制 child 在 Container 中的位置。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // topLeft
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    alignment: Alignment.topLeft,
                    child: const Text('↖', style: TextStyle(fontSize: 20)),
                  ),
                  // center
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('●', style: TextStyle(fontSize: 20)),
                  ),
                  // bottomRight
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    alignment: Alignment.bottomRight,
                    child: const Text('↘', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),

          // 5. decoration（圓角 + 邊框）
          DemoBlock(
            number: 5,
            title: 'decoration（圓角 + 邊框）',
            children: [
              Text(
                '使用 BoxDecoration 設定圓角和邊框。\n注意：用 decoration 時不能同時設 color。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: const Text('圓角 + 紫色邊框'),
              ),
            ],
          ),

          // 6. decoration（陰影）
          DemoBlock(
            number: 6,
            title: 'decoration（陰影）',
            children: [
              Text(
                '用 boxShadow 加上陰影效果。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text('我有陰影'),
              ),
            ],
          ),

          // 7. constraints（最小 / 最大尺寸限制）
          DemoBlock(
            number: 7,
            title: 'constraints（尺寸限制）',
            children: [
              Text(
                '用 constraints 限制最小 / 最大寬高。\n這個 Container 最小高度 60，會自動撐開。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 60),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal),
                ),
                alignment: Alignment.center,
                child: const Text('minHeight: 60'),
              ),
            ],
          ),

          // 8. transform（旋轉）
          DemoBlock(
            number: 8,
            title: 'transform（旋轉）',
            children: [
              Text(
                '用 transform 對 Container 做旋轉、位移等變換。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  transform: Matrix4.rotationZ(0.2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('旋轉',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}