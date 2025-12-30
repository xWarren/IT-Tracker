import 'package:flutter/material.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_image.dart';
import '../../core/common/common_text_field.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  final _messageController = TextEditingController();


  void _onChanged(String value) {
    setState(() {
      _messageController.text = value;
    });
  }

  void _send() {
    setState(() {
      _messageController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        titleWidget: const Row(
          spacing: Dimensions.spacingSmall,
          children: [
            CommonImage(
              path: Assets.logo2,
              height: 36.0,
              width: 36.0,
            ),
            Text(
              "Conversation",
              style: TextStyle(
                color: CustomColors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
        widget: [
          Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingMedium),
            child: CommonIconButton(
              onPressed: () {},
              rippleColor: Colors.transparent,
              icon: const Icon(
                Icons.phone,
                size: 24.0,
                color: CustomColors.white,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return const Text('hello');
            },
          ),
          Container(
            height: 60.0,
            margin: const EdgeInsets.symmetric(vertical: Dimensions.marginMedium),
            width: context.screenWidth,
            child: Row(
              spacing: Dimensions.spacingMedium,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingMedium),
                    child: CommonTextField(
                      controller: _messageController,
                      onChanged: _onChanged,
                      fillColor: CustomColors.white,
                      filled: true,
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        borderSide: const BorderSide(color: CustomColors.gray)
                      ),
                      hintText: "Type a message...",
                      hintTextStyle: const TextStyle(
                        color: CustomColors.gray,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingMedium),
                  child: CommonIconButton(
                    onPressed: _messageController.text.isEmpty ? null : _send,
                    backgroundColor: _messageController.text.isEmpty ? CustomColors.primary.withValues(alpha: 0.5) : null,
                    padding: EdgeInsets.zero,
                    iconSize: 54.0,
                    icon: const Icon(
                      Icons.send,
                      color: CustomColors.white,
                      size: 20.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}