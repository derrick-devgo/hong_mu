// TextField（套用 VStack + DemoBlock）
import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({super.key});

  @override
  State<TextFieldDemo> createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  // 控制器：讀取與操作輸入框文字
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  bool _obscure = true; // 控制密碼是否隱藏

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField 教學示範')),
      body: VStack(
        children: [
          // 1. 基本 TextField
          DemoBlock(
            number: 1,
            title: '基本輸入框（TextField）',
            children: [
              Text(
                '綁定 controller、使用 decoration（label、hint、prefixIcon）、'
                    '並示範 onChanged / onSubmitted。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  hintText: '請輸入你的名字',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  debugPrint('輸入中：$value');
                },
                onSubmitted: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('你送出了：$value')),
                  );
                },
              ),
            ],
          ),

          // 2. 密碼輸入框
          DemoBlock(
            number: 2,
            title: '密碼輸入框（obscureText）',
            gap: 8,
            children: [
              Text(
                '使用 obscureText 隱藏輸入，並用 suffixIcon 切換顯示/隱藏。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: '密碼',
                  hintText: '請輸入密碼',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          // 3. 數字鍵盤
          DemoBlock(
            number: 3,
            title: '數字鍵盤（keyboardType）',
            children: [
              Text(
                '用 keyboardType 指定鍵盤類型，手機上會自動彈出數字鍵盤。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.number, // 數字鍵盤
                decoration: InputDecoration(
                  labelText: '電話號碼',
                  hintText: '0912-345-678',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),

          // 4. 多行輸入框
          DemoBlock(
            number: 4,
            title: '多行輸入框（maxLines）',
            children: [
              Text(
                '設定 maxLines 讓輸入框可以換行，適合留言、備註等場景。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioController,
                maxLines: 4, // 最多顯示 4 行
                decoration: const InputDecoration(
                  labelText: '自我介紹',
                  hintText: '寫點什麼吧...',
                  alignLabelWithHint: true, // label 對齊到頂部
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),

          // 5. 字數限制
          DemoBlock(
            number: 5,
            title: '字數限制（maxLength）',
            children: [
              Text(
                'maxLength 會自動顯示字數計數器，超過就無法再輸入。',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              const TextField(
                maxLength: 20, // 最多 20 個字
                decoration: InputDecoration(
                  labelText: '暱稱',
                  hintText: '最多 20 個字',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
