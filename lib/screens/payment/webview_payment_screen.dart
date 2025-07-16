import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const WebViewPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url.contains("result=success")) {
            Navigator.pop(context, true);
          } else if (request.url.contains("result=fail")) {
            Navigator.pop(context, false);
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) async {
          // Đọc nội dung trang để kiểm tra chữ ký hợp lệ
          final html = await _controller.runJavaScriptReturningResult(
            "document.body.innerText"
          );
          if (html != null && html.toString().contains("Chữ ký hợp lệ")) {
            Navigator.pop(context, true);
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: WebViewWidget(controller: _controller),
    );
  }
}