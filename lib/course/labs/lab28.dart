import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Lab 28：WebView 內嵌網頁
/// 使用官方套件 webview_flutter。
///
/// 記得在 pubspec.yaml 加入：
///   webview_flutter: ^4.10.0
///
/// Android 最低 SDK 建議 ≥ 21（Flutter 預設已符合）。
/// iOS 不需特別設定，但若要載入 http（非 https）網址，
/// 需在 Info.plist 加 NSAppTransportSecurity / NSAllowsArbitraryLoads。
class WebViewDemo extends StatefulWidget {
  const WebViewDemo({super.key});

  @override
  State<WebViewDemo> createState() => _WebViewDemoState();
}

class _WebViewDemoState extends State<WebViewDemo> {
  late final WebViewController _controller;
  final TextEditingController _urlCtrl =
      TextEditingController(text: 'https://flutter.dev');
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      // 允許執行 JavaScript
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      // 監聽載入進度、頁面開始 / 結束、錯誤
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p),
          onPageStarted: (url) => setState(() => _progress = 0),
          onPageFinished: (url) => setState(() => _progress = 100),
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
          // 可在此攔截導航，例如不允許某些網址
          onNavigationRequest: (request) {
            // if (request.url.startsWith('https://blocked.com')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_urlCtrl.text));
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  void _loadUrl() {
    var url = _urlCtrl.text.trim();
    if (url.isEmpty) return;
    if (!url.startsWith('http')) url = 'https://$url';
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 28 - WebView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: '上一頁',
            onPressed: () async {
              if (await _controller.canGoBack()) _controller.goBack();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            tooltip: '下一頁',
            onPressed: () async {
              if (await _controller.canGoForward()) _controller.goForward();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新整理',
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 網址輸入列
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: '輸入網址',
                    ),
                    onSubmitted: (_) => _loadUrl(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loadUrl,
                  child: const Text('前往'),
                ),
              ],
            ),
          ),
          // 載入進度條
          if (_progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          // WebView 主體
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
