import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/commons/loader.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(ApiConstant.chatBotUrl));

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Listen to loading state changes
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            isLoading = true;
          });
        },
        onPageFinished: (url) {
          setState(() {
            isLoading = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Loader()
          : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: WebViewWidget(
                controller: controller,
              ),
          ),
    );
  }
}
