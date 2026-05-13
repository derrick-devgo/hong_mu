// Row 教學範例（使用 lab8 的 LabelBox）
import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';
import 'lab8.dart'; // 引入 LabelBox

class _Frame extends StatelessWidget {
  const _Frame({required this.child, this.h = 80});
  final Widget child;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}

/// ======================= Row 教學頁 =======================
class RowDemo extends StatelessWidget {
  const RowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row 教學範例')),
      body: VStack(
        children: [
          // 1. 基本 Row
          DemoBlock(
            number: 1,
            title: '基本 Row',
            subtitle: '水平方向依序排列子元件。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),

          // 主軸對齊（mainAxisAlignment）
          DemoBlock(
            number: 2,
            title: '主軸對齊：start（預設）',
            subtitle: 'children 靠左排列。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 3,
            title: '主軸對齊：center',
            subtitle: 'children 置中排列。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 4,
            title: '主軸對齊：spaceBetween',
            subtitle: '首尾貼兩端，中間平分空白。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 5,
            title: '主軸對齊：spaceAround',
            subtitle: '左右各留 0.5 份空白，中間 1 份。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 6,
            title: '主軸對齊：spaceEvenly',
            subtitle: '左右與中間空白等分。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),

          // 交叉軸對齊（crossAxisAlignment）— 用不同高度的 box 來凸顯差異
          DemoBlock(
            number: 7,
            title: '副軸對齊：start',
            subtitle: '以上緣對齊（Row 的副軸是垂直）。',
            contentHeight: 140,
            child: _Frame(
              h: 100,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 30),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 60),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 45),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 8,
            title: '副軸對齊：center（預設）',
            subtitle: '以中線對齊。',
            contentHeight: 140,
            child: _Frame(
              h: 100,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 30),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 60),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 45),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 9,
            title: '副軸對齊：end',
            subtitle: '以下緣對齊。',
            contentHeight: 140,
            child: _Frame(
              h: 100,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 30),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 60),
                  LabelBox(label: 'C', color: Colors.blue, width: 50, height: 45),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 10,
            title: '副軸對齊：stretch',
            subtitle: '子元素高度會被拉滿可用高度。',
            contentHeight: 140,
            child: _Frame(
              h: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 50, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 4),
                  Container(width: 50, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 4),
                  Container(width: 50, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)), alignment: Alignment.center, child: const Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),

          // mainAxisSize
          DemoBlock(
            number: 11,
            title: 'MainAxisSize.max（預設）',
            subtitle: 'Row 寬度撐滿可用空間。',
            contentHeight: 140,
            child: _Frame(
              child: const Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 12,
            title: 'MainAxisSize.min',
            subtitle: 'Row 只包住內容寬。',
            contentHeight: 140,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _Frame(
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                    LabelBox(label: 'B', color: Colors.green, width: 50, height: 50),
                  ],
                ),
              ),
            ),
          ),

          // Expanded / Flexible
          DemoBlock(
            number: 13,
            title: 'Expanded：撐滿剩餘空間',
            subtitle: '中間的 B 會吃掉剩餘寬度。',
            contentHeight: 140,
            child: _Frame(
              child: Row(
                children: [
                  const LabelBox(label: 'A', color: Colors.red, width: 50, height: 50),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('B（Expanded）', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const LabelBox(label: 'C', color: Colors.blue, width: 50, height: 50),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 14,
            title: 'Flexible + flex（1:2:1）',
            subtitle: '以比例分配寬度，不強制填滿高度。',
            contentHeight: 140,
            child: _Frame(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
