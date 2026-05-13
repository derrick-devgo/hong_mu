import 'package:flutter/material.dart';



class ColorTextTogglePage extends StatefulWidget {
  const ColorTextTogglePage({super.key});

  @override
  State<ColorTextTogglePage> createState() => _ColorTextTogglePageState();
}

class _ColorTextTogglePageState extends State<ColorTextTogglePage> {
  // 當前 Container 顏色
  Color _boxColor = Colors.blue;

  // 當前顯示文字
  String _label = 'Hello Flutter';

  // 點擊次數（額外示範：數值也是狀態的一種）
  int _tapCount = 0;

  // 可切換的顏色清單
  static const _colors = <Color>[
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  // 可切換的文字清單
  static const _labels = <String>[
    'Hello Flutter',
    '你好，世界',
    'setState 很簡單',
    '狀態改變畫面就會更新',
  ];

  void _changeColor() {
    setState(() {
      // 取得下一個顏色（循環）
      final next = (_colors.indexOf(_boxColor) + 1) % _colors.length;
      _boxColor = _colors[next];
      _tapCount++;
    });
  }

  void _changeText() {
    setState(() {
      final next = (_labels.indexOf(_label) + 1) % _labels.length;
      _label = _labels[next];
      _tapCount++;
    });
  }

  void _reset() {
    setState(() {
      _boxColor = Colors.blue;
      _label = 'Hello Flutter';
      _tapCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState Demo'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 動態顏色與文字的 Container
            Container(
              width: 220,
              height: 140,
              alignment: Alignment.center,
              color: _boxColor,
              child: Text(
                _label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 切換顏色按鈕
            ElevatedButton.icon(
              onPressed: _changeColor,
              icon: const Icon(Icons.palette),
              label: const Text('切換顏色'),
            ),
            const SizedBox(height: 8),
            // 切換文字按鈕
            ElevatedButton.icon(
              onPressed: _changeText,
              icon: const Icon(Icons.text_fields),
              label: const Text('切換文字'),
            ),
            const SizedBox(height: 12),
            // 重設按鈕
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('重設'),
            ),
            const SizedBox(height: 12),
            Text(
              '已點擊次數：$_tapCount',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}