import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';
import 'lab8.dart';

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
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}

/// ======================= Column 教學頁 =======================
class ColumnDemo extends StatelessWidget {
  const ColumnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column 教學範例')),
      body: VStack(
        children: [
          DemoBlock(
            number: 1,
            title: '基本 Column',
            subtitle: '垂直方向依序排列子元件。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 30),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 30),
                  LabelBox(label: 'C', color: Colors.orange, width: 40, height: 30),
                ],
              ),
            ),
          ),

          // 主軸對齊（mainAxisAlignment）
          DemoBlock(
            number: 2,
            title: '主軸對齊：start（預設）',
            subtitle: 'children 靠上排列。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                  LabelBox(label: 'C', color: Colors.orange, width: 40, height: 24),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 3,
            title: '主軸對齊：center',
            subtitle: 'children 垂直置中。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                  LabelBox(label: 'C', color: Colors.orange, width: 40, height: 24),
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
              h: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                  LabelBox(label: 'C', color: Colors.orange, width: 40, height: 24),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 5,
            title: '主軸對齊：spaceEvenly',
            subtitle: '上下與中間空白等分。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                  LabelBox(label: 'C', color: Colors.orange, width: 40, height: 24),
                ],
              ),
            ),
          ),

          // 交叉軸對齊（crossAxisAlignment）
          DemoBlock(
            number: 6,
            title: '副軸對齊：start',
            subtitle: '以左側對齊（Column 的副軸是水平）。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 80, height: 28),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 28),
                  LabelBox(label: 'C', color: Colors.orange, width: 30, height: 28),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 7,
            title: '副軸對齊：center（預設）',
            subtitle: '以中線對齊。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 80, height: 28),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 28),
                  LabelBox(label: 'C', color: Colors.orange, width: 30, height: 28),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 8,
            title: '副軸對齊：end',
            subtitle: '以右側對齊。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 80, height: 28),
                  LabelBox(label: 'B', color: Colors.green, width: 50, height: 28),
                  LabelBox(label: 'C', color: Colors.orange, width: 30, height: 28),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 9,
            title: '副軸對齊：stretch',
            subtitle: '子元素寬度會被拉滿可用寬度。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(height: 28, color: Colors.blue, alignment: Alignment.center, child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  Container(height: 28, color: Colors.green, alignment: Alignment.center, child: const Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  Container(height: 28, color: Colors.orange, alignment: Alignment.center, child: const Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),

          // mainAxisSize
          DemoBlock(
            number: 10,
            title: 'MainAxisSize.max（預設）',
            subtitle: 'Column 高度撐滿可用空間。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 11,
            title: 'MainAxisSize.min',
            subtitle: 'Column 只包住內容高。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                        LabelBox(label: 'B', color: Colors.green, width: 40, height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('← 紅框 = Column 範圍', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),

          // Expanded / Flexible
          DemoBlock(
            number: 12,
            title: 'Expanded：撐滿剩餘空間',
            subtitle: '中間的 B 會吃掉剩餘高度。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                children: [
                  const LabelBox(label: 'A', color: Colors.blue, width: 40, height: 24),
                  Expanded(
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const LabelBox(label: 'C', color: Colors.orange, width: 40, height: 24),
                ],
              ),
            ),
          ),
          DemoBlock(
            number: 13,
            title: 'Flexible + flex（1:2:1）',
            subtitle: '以比例分配高度，不強制填滿寬度。',
            contentHeight: 140,
            child: _Frame(
              h: 120,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
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
