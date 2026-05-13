// lib/labs/lab24.dart
//
// 使用 Firebase Auth REST API 實作登入（不需要 firebase_core / flutterfire configure）
// 文件：https://firebase.google.com/docs/reference/rest/auth
//
// ⚠️ 使用前：把下面 _apiKey 換成你 Firebase 專案的 Web API Key
//   位置：Firebase Console → 專案設定 → 一般設定 → Web API 金鑰

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ===== 1. 把這裡換成你的 Web API Key =====
const String _apiKey = '請貼上你的 Web API Key';

class Lab24LoginPage extends StatefulWidget {
  const Lab24LoginPage({super.key});

  @override
  State<Lab24LoginPage> createState() => _Lab24LoginPageState();
}

class _Lab24LoginPageState extends State<Lab24LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _message;

  // 登入後保存的資料
  String? _idToken;
  String? _refreshToken;
  String? _localId; // 等同 user uid
  String? _email;

  bool get _isLoggedIn => _idToken != null;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ============ 核心：呼叫 Firebase Auth REST ============
  Future<Map<String, dynamic>> _post(String endpoint, Map body) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$endpoint?key=$_apiKey',
    );
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) {
      // 失敗時 data['error']['message'] 例如 EMAIL_EXISTS / INVALID_PASSWORD
      final msg = data['error']?['message'] ?? '未知錯誤';
      throw Exception(msg);
    }
    return data;
  }

  // ===== 註冊 =====
  Future<void> _register() => _runForm(() async {
        final data = await _post('signUp', {
          'email': _emailCtrl.text.trim(),
          'password': _passwordCtrl.text,
          'returnSecureToken': true,
        });
        _saveSession(data);
        return '✅ 註冊成功：${data['email']}';
      });

  // ===== 登入 =====
  Future<void> _login() => _runForm(() async {
        final data = await _post('signInWithPassword', {
          'email': _emailCtrl.text.trim(),
          'password': _passwordCtrl.text,
          'returnSecureToken': true,
        });
        _saveSession(data);
        return '✅ 登入成功：${data['email']}';
      });

  // ===== 匿名登入 =====
  Future<void> _signInAnonymously() => _run(() async {
        final data = await _post('signUp', {'returnSecureToken': true});
        _saveSession(data);
        return '✅ 匿名登入成功，UID: ${data['localId']}';
      });

  // ===== 取得使用者資訊（驗證 token 是否有效）=====
  Future<void> _fetchUserInfo() => _run(() async {
        if (_idToken == null) throw Exception('尚未登入');
        final data = await _post('lookup', {'idToken': _idToken});
        final users = data['users'] as List;
        return '👤 user info: ${jsonEncode(users.first)}';
      });

  // ===== 登出（REST 沒有 signOut，僅清除本地狀態）=====
  void _signOut() {
    setState(() {
      _idToken = null;
      _refreshToken = null;
      _localId = null;
      _email = null;
      _message = '👋 已登出';
    });
  }

  // ----- 工具方法 -----
  void _saveSession(Map<String, dynamic> data) {
    _idToken = data['idToken'];
    _refreshToken = data['refreshToken'];
    _localId = data['localId'];
    _email = data['email'];
  }

  Future<void> _runForm(Future<String> Function() action) async {
    if (!_formKey.currentState!.validate()) return;
    return _run(action);
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final msg = await action();
      setState(() => _message = msg);
    } catch (e) {
      setState(() =>
          _message = '❌ ${e.toString().replaceFirst("Exception: ", "")}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ============ UI ============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab24 - Firebase REST 登入')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 狀態卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _isLoggedIn
                      ? '👤 已登入\nUID: $_localId\nEmail: ${_email ?? "(匿名)"}\nidToken: ${_idToken!.substring(0, 20)}...'
                      : '🔒 尚未登入',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 表單
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return '請輸入 Email';
                      if (!v.contains('@')) return 'Email 格式錯誤';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) return '請輸入密碼';
                      if (v.length < 6) return '密碼至少 6 碼';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 按鈕
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _login,
                    icon: const Icon(Icons.login),
                    label: const Text('登入'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _register,
                    icon: const Icon(Icons.person_add),
                    label: const Text('註冊'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loading ? null : _signInAnonymously,
              icon: const Icon(Icons.person_outline),
              label: const Text('匿名登入'),
            ),
            const SizedBox(height: 8),
            if (_isLoggedIn) ...[
              OutlinedButton.icon(
                onPressed: _loading ? null : _fetchUserInfo,
                icon: const Icon(Icons.info_outline),
                label: const Text('取得使用者資訊'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text('登出'),
              ),
            ],

            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.startsWith('❌') ? Colors.red : Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
