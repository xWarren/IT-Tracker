import 'package:flutter/material.dart';

import '../../core/common/common_appbar.dart';
import '_components/receiving_content.dart';
import '_components/waiting_content.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Receive"),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          WaitingContent(),
          ReceivingContent()
        ],
      ),
    );
  }
}