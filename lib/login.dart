import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const _primaryColor = Color(0xFFE7393E);
const _textPrimaryColor = Color(0xFF333333);
const _textSecondaryColor = Color(0xFF888888);
const _borderColor = Color(0xFFE7E3E3);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscureText = true;
  bool _isBusy = false;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _signIn() async {
    final email = _accountController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showSnack('請輸入帳號');
      return;
    }

    if (password.isEmpty) {
      _showSnack('請輸入密碼');
      return;
    }

    if (password.length < 6) {
      _showSnack('密碼至少需要 6 碼');
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? '登入失敗');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _accountController.text.trim();

    if (email.isEmpty) {
      _showSnack('請先輸入帳號');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnack('已寄出重設密碼信');
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? '寄送失敗');
    }
  }

  OutlineInputBorder _inputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildBrandHeader() {
    return const Column(
      children: [
        Text(
          '紅木蛋糕',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textPrimaryColor,
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.64,
          ),
        ),
        SizedBox(height: 7),
        Text(
          'Hong Mu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          style: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: _inputBorder(_borderColor, 1),
            focusedBorder: _inputBorder(_primaryColor, 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            activeColor: _primaryColor,
            side: const BorderSide(color: _primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          '記住我',
          style: TextStyle(
            color: _textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: _forgotPassword,
          style: TextButton.styleFrom(
            foregroundColor: _primaryColor,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            '忘記密碼',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isBusy ? null : _signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.all(12),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        _isBusy ? '登入中...' : '登入',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),
              _buildBrandHeader(),
              const SizedBox(height: 70),
              _buildTextField(
                label: '帳號',
                controller: _accountController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: '密碼',
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: _textSecondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionsRow(),
              const SizedBox(height: 95),
              _buildLoginButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
