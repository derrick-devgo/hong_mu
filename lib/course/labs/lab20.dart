import 'package:flutter/material.dart';

class BottomNavigationBarDemo extends StatefulWidget {
  const BottomNavigationBarDemo({super.key});
  @override
  State<BottomNavigationBarDemo> createState() => _BottomNavigationBarDemoState();
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo> {
  int _currentIndex = 0;

  // 將頁面定義為 final，避免每次 build 重新建立
  final List<Widget> _pages = const [
    HomeTab(),
    SearchTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BottomNavigationBar Demo')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber, // 選中項目的顏色（取代舊的 fixedColor）
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁', // 取代舊的 title: Text(...)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜尋',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}

// ===== 三個獨立的 Stateless 分頁 =====
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('首頁內容'));
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('搜尋內容'));
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('設定內容'));
}