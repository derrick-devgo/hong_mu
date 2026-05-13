import 'package:flutter/material.dart';

// 應用程式的主要頁面，包含 Scaffold 和 Drawer
class DrawerDemo extends StatelessWidget {
  const DrawerDemo({super.key});

  // 輔助函式：處理點擊事件並關閉 Drawer
  void _onTileTap(BuildContext context, String title) {
    // 先關閉 Drawer（等同於按下返回鍵）
    Navigator.pop(context);

    // 再顯示 SnackBar 通知使用者點了哪個項目
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('你點擊了：「$title」')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer 側邊抽屜範例'),
      ),

      // =======================================================
      // 核心：Drawer 元件
      // =======================================================
      drawer: Drawer(
        child: ListView(
          // 移除 ListView 預設的上方 padding，讓 DrawerHeader 貼齊頂部
          padding: EdgeInsets.zero,
          children: [
            // ── 頂部 Header ──────────────────────────────────
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flutter 學員',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'student@flutter.dev',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // ── 導航項目 ─────────────────────────────────────
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('首頁'),
              onTap: () => _onTileTap(context, '首頁'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('個人資料'),
              onTap: () => _onTileTap(context, '個人資料'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () => _onTileTap(context, '設定'),
            ),

            // ── 分隔線 ───────────────────────────────────────
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('登出', style: TextStyle(color: Colors.red)),
              onTap: () => _onTileTap(context, '登出'),
            ),
          ],
        ),
      ),

      body: const Center(
        child: Text(
          '點擊左上角的圖示來開啟側邊抽屜 (Drawer)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}