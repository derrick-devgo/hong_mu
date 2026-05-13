// dialog_demo.dart
import 'package:flutter/material.dart';

class DialogDemo extends StatelessWidget {
  const DialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog 教學範例')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1️⃣ AlertDialog：提示訊息＋按鈕
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: const Text('顯示 AlertDialog'),
            ),
            const SizedBox(height: 16),

            // 2️⃣ SimpleDialog：單選列表
            ElevatedButton(
              onPressed: () => _showSimpleDialog(context),
              child: const Text('顯示 SimpleDialog'),
            ),
            const SizedBox(height: 16),

            // 3️⃣ 自訂 Dialog：完全客製
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: const Text('顯示 Custom Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. AlertDialog: 標題、內容、actions
  /// BuildContext context之後要補給同學，告訴他們原理
  /// 答案: BuildContext是Flutter中用來定位Widget在Widget樹中的位置的對象。當我們呼叫showDialog時，需要提供一個BuildContext，這個context會被用來找到當前顯示的Widget，並將對話框顯示在它的上方。通常我們會使用Scaffold或其他父級Widget的context來確保對話框能夠正確地顯示在整個畫面上。
  void _showAlertDialog(BuildContext context) {
    // 欠同學講觀念，showDialog到底是Widget還是方法?
    // showDialog是Flutter內建的方法，用來顯示一個對話框。它接受一個BuildContext和一個builder函數，builder函數返回一個Widget，這個Widget就是我們要顯示的對話框內容。
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除確認'),
        content: const Text('確定要刪除這筆資料嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 2. SimpleDialog: 標題 + SimpleDialogOption 列表
  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('選擇語言'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('繁體中文'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('日本語'),
          ),
        ],
      ),
    );
  }

  /// 3. Custom Dialog: 完全自訂佈局
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text(
                '操作成功！',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('您的資料已成功儲存。'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('好的'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}