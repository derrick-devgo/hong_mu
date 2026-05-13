// 練習 1：用網路圖片、文字、按鈕，做出一張「美食介紹卡片」
//
// 🎯 目標畫面（由上到下）：
//   ┌──────────────────────────┐
//   │        （美食圖片）         │  ← 網路圖片，高度 200，寬度撐滿
//   ├──────────────────────────┤
//   │  🍜 日式拉麵              │  ← 標題文字（粗體、大字）
//   │  濃郁豚骨湯頭，搭配叉燒、  │  ← 說明文字（灰色、小字）
//   │  溏心蛋與蔥花，一碗滿足！  │
//   │                          │
//   │  [ 🛒 我要點餐 ]          │  ← 按鈕，點擊後顯示 SnackBar
//   └──────────────────────────┘
//
// 📝 提示：
//   1. 用 Image.network() 載入圖片，記得加上 fit: BoxFit.cover
//   2. 用 SizedBox 控制圖片高度
//   3. 用 Text() 顯示標題和說明
//   4. 用 ElevatedButton / ElevatedButton.icon() 做按鈕
//   5. 按鈕點擊事件：ScaffoldMessenger.of(context).showSnackBar(...)
//   6. 用 SizedBox(height: __) 在元件之間加間距
//
// 🖼️ 可使用的圖片網址（也可以自己找喜歡的圖）：
//   https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800

import 'package:flutter/material.dart';

class Practice1 extends StatelessWidget {
  const Practice1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('練習1：美食介紹卡片')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO 1: 用 SizedBox + Image.network 放一張美食圖片
            //         高度 200、寬度撐滿（double.infinity）
            //         fit 用 BoxFit.cover


            // TODO 2: 加一個 SizedBox(height: 16) 當間距


            // TODO 3: 放標題文字「🍜 日式拉麵」
            //         提示：style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)


            // TODO 4: 加一個 SizedBox(height: 8) 當間距


            // TODO 5: 放說明文字「濃郁豚骨湯頭，搭配叉燒、溏心蛋與蔥花，一碗滿足！」
            //         提示：style: TextStyle(fontSize: 16, color: Colors.grey[700])


            // TODO 6: 加一個 SizedBox(height: 24) 當間距


            // TODO 7: 放一個按鈕「🛒 我要點餐」
            //         點擊後用 ScaffoldMessenger 顯示 SnackBar：「已加入點餐清單！」
            //         提示：
            //         ElevatedButton(
            //           onPressed: () {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(content: Text('已加入點餐清單！')),
            //             );
            //           },
            //           child: Text('🛒 我要點餐'),
            //         ),

            SizedBox(
  height: 200,
  width: double.infinity,
  child: Image.network(
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
    fit: BoxFit.cover,
  ),
),
const SizedBox(height: 16),
const Text(
  '🍜 日式拉麵',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
Text(
  '濃郁豚骨湯頭，搭配叉燒、溏心蛋與蔥花，一碗滿足！',
  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
),
const SizedBox(height: 24),
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已加入點餐清單！')),
    );
  },
  child: const Text('🛒 我要點餐'),
),

          ],
        ),
      ),
    );
  }
}


// ══════════════════════════════════════════════════════════════
// ✅ 參考答案（寫完再看！）
// ══════════════════════════════════════════════════════════════
//
// SizedBox(
//   height: 200,
//   width: double.infinity,
//   child: Image.network(
//     'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
//     fit: BoxFit.cover,
//   ),
// ),
// const SizedBox(height: 16),
// const Text(
//   '🍜 日式拉麵',
//   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// ),
// const SizedBox(height: 8),
// Text(
//   '濃郁豚骨湯頭，搭配叉燒、溏心蛋與蔥花，一碗滿足！',
//   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
// ),
// const SizedBox(height: 24),
// ElevatedButton(
//   onPressed: () {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('已加入點餐清單！')),
//     );
//   },
//   child: const Text('🛒 我要點餐'),
// ),