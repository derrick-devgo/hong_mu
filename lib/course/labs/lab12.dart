// lab12.dart — ListTile 介紹（純 Stateless，不含狀態切換）
import 'package:flutter/material.dart';
import '../vstack.dart';
import '../demo_block.dart';

/// ListTile 是 Material Design 中常用的「列表項」元件。
/// 典型結構：
///   [leading]  [title]           [trailing]
///              [subtitle]
/// 常用於設定頁、通訊錄、選單、通知列表等。
class ListTileDemo extends StatelessWidget {
  const ListTileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListTile 教學範例')),
      body: VStack(
        children: [
          // 1. 最基本：只有 title
          DemoBlock(
            number: 1,
            title: '最基本的 ListTile（只有 title）',
            subtitle: 'ListTile 至少會包一個 title。',
            contentHeight: 80,
            child: const ListTile(
              title: Text('我是一個最簡單的 ListTile'),
            ),
          ),

          // 2. leading + title + subtitle + trailing
          DemoBlock(
            number: 2,
            title: 'leading / title / subtitle / trailing',
            subtitle: '四個標準位置：左圖示、主標題、副標題、右側元件。',
            contentHeight: 100,
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('王小明'),
              subtitle: Text('xiaoming@example.com'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          // 3. 可點擊：onTap
          DemoBlock(
            number: 3,
            title: '可點擊（onTap）',
            subtitle: '加上 onTap 後整塊都能點，會有漣漪 (ripple) 效果。',
            contentHeight: 100,
            child: Builder(
              builder: (context) => ListTile(
                leading: const Icon(Icons.notifications, color: Colors.orange),
                title: const Text('點我試試'),
                subtitle: const Text('整個 tile 區域都可點擊'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('你點擊了這個 ListTile'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ),

          // 4. leading 用 CircleAvatar
          DemoBlock(
            number: 4,
            title: 'leading 使用 CircleAvatar（大頭貼）',
            subtitle: '常見於通訊錄 / 聊天列表。',
            contentHeight: 100,
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text('王', style: TextStyle(color: Colors.white)),
              ),
              title: Text('王小明'),
              subtitle: Text('最後上線：剛剛'),
              trailing: Icon(Icons.chat_bubble_outline),
            ),
          ),

          // 5. 自訂樣式：dense / contentPadding / shape / tileColor
          DemoBlock(
            number: 5,
            title: '自訂樣式：dense / shape / tileColor',
            subtitle: 'dense 讓列更緊湊；shape 可做出圓角卡片感。',
            contentHeight: 110,
            child: ListTile(
              dense: true,
              tileColor: Colors.purple.shade50,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.favorite, color: Colors.white, size: 18),
              ),
              title: const Text('自訂外觀的 ListTile'),
              subtitle: const Text('圓角 + 背景色 + 緊湊模式'),
              trailing: const Icon(Icons.more_vert),
            ),
          ),

          // 6. 搭配 Divider 組成列表
          DemoBlock(
            number: 6,
            title: '搭配 Divider 組成列表',
            subtitle: '實務上 ListTile 通常和 ListView + Divider 一起使用。',
            contentHeight: 220,
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.inbox, color: Colors.blue),
                  title: Text('收件匣'),
                  trailing: Text('12'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.send, color: Colors.green),
                  title: Text('寄件備份'),
                  trailing: Text('3'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.drafts, color: Colors.orange),
                  title: Text('草稿'),
                  trailing: Text('1'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('垃圾桶'),
                  trailing: Text('0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
