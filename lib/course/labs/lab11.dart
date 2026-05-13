// lab11: 用 Row 和 Column 做一個簡單的登入畫面
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─── Preview ───
@Preview(name: 'Login Page Preview', size: Size(400, 700))
Widget loginPagePreview() => const MaterialApp(home: LoginPage());

// ─── 登入頁面 ───
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo 區 ──
              Center(
                child: const Text(
                  '歡迎回來',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 4),
              Text(
                '請登入你的帳號',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),

              const SizedBox(height: 40),

              // ── Email 輸入 ──
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // ── 密碼輸入 ──
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密碼',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              // ── 忘記密碼（Row 靠右）──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: const Text('忘記密碼？')),
                ],
              ),

              const SizedBox(height: 16),

              // ── 登入按鈕 ──
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('登入', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 24),

              // ── 分隔線（Row: 線 + 文字 + 線）──
              const Divider(thickness: 1),

              const SizedBox(height: 24),

              // ── 社群登入（Row: 三個圖片按鈕）──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialLoginButton(
                    assetPath: 'assets/svg/google-login.svg',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  _SocialLoginButton(
                    assetPath: 'assets/svg/apple-login.svg',
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  _SocialLoginButton(
                    assetPath: 'assets/svg/facebook-login.svg',
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── 註冊提示（Row: 文字 + 按鈕置中）──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('還沒有帳號？'),
                  TextButton(onPressed: () {}, child: const Text('註冊')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 簡單 Row + Column 練習 ───
class SimpleRowColumnDemo extends StatelessWidget {
  const SimpleRowColumnDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row + Column 簡單練習')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 左邊：頭像
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Text(
                  'T',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              // 右邊：用 Column 垂直排文字
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '同學你好',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '這是一個 Row + Column 的範例',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 社群登入圖片按鈕 ──
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({required this.assetPath, required this.onPressed});

  final String assetPath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}
