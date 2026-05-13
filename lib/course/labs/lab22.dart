import 'package:flutter/material.dart';


class NavigationDemo extends StatelessWidget {
  const NavigationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigator.push Demo',
      home: const PageA(),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page A')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 跳到 Page B（不傳資料）
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageB()),
                );
              },
              child: const Text('前往 Page B（不傳資料）'),
            ),
            const SizedBox(height: 16),
            // 跳到 Page C（傳資料）
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PageC(sentData: '來自 Page A 的問候！'),
                  ),
                );
              },
              child: const Text('前往 Page C（傳資料）'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page B')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('這是 Page B，沒有收到任何資料。'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('返回 Page A'),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// Page C: 接收 Page A 傳來的資料並顯示
// ====================================================================

class PageC extends StatelessWidget {
  // 接收 Page A 傳來的資料
  final String sentData;

  const PageC({super.key, required this.sentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page C (接收資料頁)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('從 Page A 收到的資料：', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              sentData,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('返回 Page A'),
            ),
          ],
        ),
      ),
    );
  }
}
