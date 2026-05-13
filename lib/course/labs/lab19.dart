// selection_controls_demos.dart
import 'package:flutter/material.dart';
import '../vstack.dart';
import '../demo_block.dart';

enum Flavor { vanilla, chocolate, strawberry }

class SelectionControlsDemo extends StatefulWidget {
  const SelectionControlsDemo({super.key});
  @override
  State<SelectionControlsDemo> createState() => _SelectionControlsDemoState();
}

class _SelectionControlsDemoState extends State<SelectionControlsDemo> {
  // 1) Checkbox
  bool _checked = false;

  // 2) CheckboxListTile
  bool _notifyEmail = true;
  bool _notifyPush = false;

  // 3) Radio / RadioListTile
  Flavor _flavor = Flavor.vanilla;

  // 4) Switch
  bool _darkMode = false;

  // 5) ToggleButtons
  final List<bool> _toggled = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selection Controls 教學範例')),
      body: VStack(
        children: [
          // 1. 基本 Checkbox
          DemoBlock(
            number: 1,
            title: 'Checkbox（單一布林選項）',
            subtitle: '最基本的勾選框，用 onChanged 搭配 setState 更新 UI。',
            contentHeight: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _checked,
                  onChanged: (val) => setState(() => _checked = val!),// 解說: Checkbox 的 onChanged 會傳回新的布林值，直接用 setState 更新 _checked 就會觸發 UI 重建，顯示新的狀態。val是一個可為 null 的布林值（bool?），因為 Checkbox 也可以有第三種狀態（null）。但在這裡我們只使用 true/false，所以用 val! 強制轉換成非 null 的布林值。
                ),
                Text(_checked ? '已勾選 ✅' : '未勾選'),
              ],
            ),
          ),

          // 2. CheckboxListTile
          DemoBlock(
            number: 2,
            title: 'CheckboxListTile（列表項勾選）',
            subtitle: '整塊可點擊，適合設定頁的條列式選項。',
            contentHeight: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CheckboxListTile(
                  title: const Text('Email 通知'),
                  value: _notifyEmail,
                  onChanged: (val) => setState(() => _notifyEmail = val!),
                ),
                CheckboxListTile(
                  title: const Text('推播通知'),
                  value: _notifyPush,
                  onChanged: (val) => setState(() => _notifyPush = val!),
                ),
              ],
            ),
          ),

          // 3. Radio（單選）
          DemoBlock(
            number: 3,
            title: 'Radio / 單選（使用 RadioGroup 管理群組）',
            subtitle: 'Flutter 3.32+ 新做法：用 RadioGroup 包住所有 Radio，'
                '由它統一管理 groupValue 與 onChanged。',
            contentHeight: 140,
            child: RadioGroup<Flavor>(
              groupValue: _flavor,
              onChanged: (val) => setState(() => _flavor = val!),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  RadioListTile<Flavor>(
                    title: Text('vanilla'),
                    value: Flavor.vanilla,
                  ),
                  RadioListTile<Flavor>(
                    title: Text('chocolate'),
                    value: Flavor.chocolate,
                  ),
                  RadioListTile<Flavor>(
                    title: Text('strawberry'),
                    value: Flavor.strawberry,
                  ),
                ],
              ),
            ),
          ),

          // 4. Switch（開關）
          DemoBlock(
            number: 4,
            title: 'Switch（開關）',
            subtitle: '切換 on/off 狀態，常見於偏好設定。',
            contentHeight: 120,
            child: SwitchListTile(
              title: const Text('深色模式'),
              subtitle: Text(_darkMode ? '已開啟' : '已關閉'),
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
          ),

          // 5. ToggleButtons（多重切換）
          DemoBlock(
            number: 5,
            title: 'ToggleButtons（多重切換）',
            subtitle: '可同時選多個；用 isSelected 控制每顆按鈕的狀態。',
            contentHeight: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: _toggled,
                  onPressed: (i) => setState(() => _toggled[i] = !_toggled[i]),
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('粗體'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('斜體'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('底線'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '已選：${[
                    if (_toggled[0]) '粗體',
                    if (_toggled[1]) '斜體',
                    if (_toggled[2]) '底線',
                  ].join('、')}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
