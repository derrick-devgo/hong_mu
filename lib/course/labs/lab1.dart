//Text,Center,SizedBox,Divider
import 'package:flutter/material.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Widget 範例')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 最基本用法：只給字串
            const Text('Hello, Flutter!'),
            

            // 加上樣式：藍色、20sp、粗體
            const Text(
              'Hello, Flutter!',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),


            // decoration參數
            // 底線
            const Text(
              'Hello, Flutter!',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            // 中間刪除線
            const Text(
              'Hello, Flutter!',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
            ),


            // 多行 +超出行數省略號
            const Text(
              'Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              maxLines: 2,
              // overflow: TextOverflow.ellipsis, // 超出行數以省略號顯示
              // overflow: TextOverflow.fade, // 超出行數以漸變淡出
              // overflow: TextOverflow.clip, // 超出行數直接裁切
              overflow: TextOverflow.visible, // 超出行數直接顯示（不裁切）
              // 同學反應TextOverflow.clip跟visible好像沒什麼差別，實際上在這個例子中是因為Text本身沒有背景色，所以看不出來被裁切了。可以把Text放在Container裡並設定背景色來測試看看：
              // Container(
              //   color: Colors.yellow,
              //   child: Text(
              //     'Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              //     maxLines: 2,
              //     overflow: TextOverflow.clip, // 超出行數直接裁切
              //   ),
              // ),
            ),


            // 可及性：螢幕閱讀器會朗讀 semanticsLabel
            const Text(
              'Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              semanticsLabel: 'Flutter 是 Google 的 UI 工具包，用於從單一代碼庫構建美觀、原生編譯的移動、網絡和桌面應用程序。',
            ),

          ],
        ),
      ),
    );
  }
}

//使用系統顏色
//Colors.red
//使用 8 個 16 進制自定義顏色
//Color(0xFFFF0000)
//使用 ARGB 自定義顏色 (A,R,G,B)，第一個欄位為 Alpha 透明度
//Color.fromARGB(255, 255, 0, 0)