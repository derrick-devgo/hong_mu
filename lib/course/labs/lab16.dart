import 'package:flutter/material.dart';

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('基本 ListView 示例')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8), // 上下內距
        children: const [
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue),
            title: Text('首頁'),
            subtitle: Text('回到主畫面'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.green),
            title: Text('個人資料'),
            subtitle: Text('檢視與編輯個人資訊'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('設定'),
            subtitle: Text('應用程式設定'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.red),
            title: Text('通知'),
            subtitle: Text('管理通知偏好'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.purple),
            title: Text('關於'),
            subtitle: Text('應用程式資訊'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}

class ListViewBuilderDemo extends StatelessWidget {
  const ListViewBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // 模擬一組資料
    final items = List<String>.generate(50, (i) => '項目 ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('動態 ListView.builder 示例')),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),// 在每個項目之間插入分隔線
        itemBuilder: (context, index) {// itemBuilder 是 ListView.builder 的參數，用來構建每個項目的 Widget。它接受一個 BuildContext 和當前項目的索引，並返回一個 Widget。在這裡，我們使用 ListTile 來顯示每個項目的內容，並根據索引來設定不同的圖示和文字。
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[index % Colors.primaries.length],
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(items[index]),
            subtitle: Text('這是第 ${index + 1} 個項目的說明'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('你點擊了 ${items[index]}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}