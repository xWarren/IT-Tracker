import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_icon_button.dart';
import '../../core/common/common_image.dart';
import '../../core/common/common_text_field.dart';
import '../../core/domain/entity/conversation_mesage_entity.dart';
import '../../core/resources/assets.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/dimensions.dart';
import '../../core/utils/context_extension.dart';
import '../../core/utils/date_time_extension.dart';
import '../../core/utils/enum/message_type_enum.dart';
import 'bloc/conversation_bloc.dart';

class ConversationPage extends StatefulWidget {

  const ConversationPage({
    super.key,
    required this.deviceId,
    required this.deviceName
  });

  final String deviceId;
  final String deviceName;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ConversationMessageEntity> messages = [];

  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;

  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _getConversation();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    _openAudioSession();

    _messageController.addListener(() {
      setState(() {});
    });
  }

  void _getConversation() {
    context.read<ConversationBloc>().add(LoadConversationEvent());
  }

  void _send() {
    if (_messageController.text.isEmpty) return;

    context.read<ConversationBloc>().add(SendTextMessageEvent(_messageController.text),);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openAudioSession() async {
    await _audioRecorder?.openRecorder();
    await _audioPlayer?.openPlayer();
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _startRecording() async {
    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    _recordedFilePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

    await _audioRecorder!.startRecorder(
      toFile: _recordedFilePath,
      codec: Codec.aacADTS,
    );

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _audioRecorder?.stopRecorder();
    setState(() => _isRecording = false);

    if (_recordedFilePath != null) {
      final audioFile = File(_recordedFilePath!);
      context.read<ConversationBloc>().add(SendAudioMessageEvent(audioFile));
      _scrollToBottom();
    }
  }

  Future<void> _playAudioWhenReady(String path, {int retries = 30, int delayMs = 500}) async {
    final file = File(path);

    if (await file.exists()) {
      debugPrint("Audio file ready: $path, starting playback");
      if (_audioPlayer!.isPlaying) {
        await _audioPlayer?.stopPlayer();
      }

      await _audioPlayer?.startPlayer(
        fromURI: path,
        whenFinished: () => setState(() {}),
      );
    } else if (retries > 0) {
      debugPrint("File not ready yet: $path, retries left: $retries");
      await Future.delayed(Duration(milliseconds: delayMs));
      await _playAudioWhenReady(path, retries: retries - 1, delayMs: delayMs);
    } else {
      debugPrint("Audio file not found after retries: $path");
    }                                         
  }





  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder?.closeRecorder();
    _audioPlayer?.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationLoaded) {
          messages = state.messages;
          _scrollToBottom();

          if (messages.isNotEmpty) {
            final lastMessage = messages.last;

            if (!lastMessage.isMe &&
                lastMessage.type == MessageTypeEnum.audio &&
                lastMessage.filePath != null) {
              _playAudioWhenReady(lastMessage.filePath!);
            }
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: context.dismissKeyboard,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: CustomColors.white,
            appBar: CommonAppBar(
              titleWidget: Row(
                spacing: Dimensions.spacingSmall,
                children: [
                  const CommonImage(
                    path: Assets.logo2,
                    height: 36.0,
                    width: 36.0,
                  ),
                  Text(
                    widget.deviceName,
                    style: const TextStyle(
                      color: CustomColors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final item = messages[index];
                      final isSender = item.isMe;
                        
                      bool showDateSeparator = false;
                      if (index == 0) {
                        showDateSeparator = true;
                      } else {
                        final prev = messages[index - 1];
                        showDateSeparator = !isSameDay(prev.createdAt, item.createdAt);
                      }
                        
                      Widget messageWidget;
                      if (item.type == MessageTypeEnum.audio && item.filePath != null) {
                        messageWidget = _voiceMessage(item.filePath!, isSender: isSender, time: item.createdAt);
                      } else {
                        messageWidget = isSender
                            ? _senderMessage(message: item.text ?? "", time: item.createdAt)
                            : _recipientMessage(message: item.text ?? "", time: item.createdAt);
                      }
                        
                      return Column(
                        children: [
                          if (showDateSeparator) _buildDateSeparator(item.createdAt),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
                            child: messageWidget,
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ],
            ),
            bottomSheet: _buildMessageInput(),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSeparator(DateTime date) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Dimensions.marginMedium),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: CustomColors.gray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        ),
        child: Text(
          date.toReadableDate(),
          style: const TextStyle(
            color: CustomColors.gray,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildMessageInput() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              spacing: Dimensions.spacingMedium,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingMedium),
                    child: CommonTextField(
                      controller: _messageController,
                      onChanged: (_) => setState(() {}),
                      contentPadding: const EdgeInsets.all(Dimensions.spacingSmall),
                      fillColor: CustomColors.white,
                      filled: true,
                      maxLines: 5,
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        borderSide: const BorderSide(color: CustomColors.gray),
                      ),
                      hintText: "Type a message...",
                      hintTextStyle: const TextStyle(
                        color: CustomColors.gray,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSmall),
                        child: CommonIconButton(
                          onPressed: _isRecording ? _stopRecording : _startRecording,
                          backgroundColor: _isRecording ? Colors.red : CustomColors.white,
                          iconSize: 32.0,
                          icon: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: _isRecording ? Colors.white : CustomColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingMedium),
                  child: CommonIconButton(
                    onPressed: _messageController.text.isEmpty ? null : _send,
                    backgroundColor: _messageController.text.isEmpty
                    ? CustomColors.primary.withValues(alpha: 0.5)
                    : CustomColors.primary,
                    padding: EdgeInsets.zero,
                    iconSize: 54.0,
                    icon: const Icon(
                      Icons.send,
                      color: CustomColors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36.0)
          ],
        ),
      ),
    );
  }

  Widget _voiceMessage(String path, {required bool isSender, required DateTime time}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isSender ? CustomColors.primary : CustomColors.gray.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _audioPlayer!.isPlaying ? Icons.stop : Icons.play_arrow,
                    color: isSender ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    if (_audioPlayer!.isPlaying) {
                      await _audioPlayer!.stopPlayer();
                      setState(() {});
                    } else {
                      await _audioPlayer!.startPlayer(
                        fromURI: path,
                        whenFinished: () => setState(() {}),
                      );
                      setState(() {});
                    }
                  },
                ),
                FutureBuilder<String>(
                  future: _getAudioDuration(path),
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? "";
                    return Text(
                      duration,
                      style: TextStyle(
                        color: isSender ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              time.toReadableTime(),
              style: const TextStyle(
                color: CustomColors.gray,
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<String> _getAudioDuration(String path) async {
    try {
      final player = AudioPlayer();
      await player.setFilePath(path);
      final duration = player.duration;
      await player.dispose();

      if (duration == null) return "";

      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    } catch (e) {
      return "";
    }
  }




  Widget _senderMessage({required String message, required DateTime time}) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSmall),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: const BoxDecoration(
          color: CustomColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusMedium),
            topRight: Radius.circular(Dimensions.radiusMedium),
            bottomLeft: Radius.circular(Dimensions.radiusMedium),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: CustomColors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time.toReadableTime(),
              style: const TextStyle(
                color: CustomColors.gray,
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _recipientMessage({required String message, required DateTime time}) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSmall),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.marginSmall),
            decoration: BoxDecoration(
              color: CustomColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusMedium),
                topRight: Radius.circular(Dimensions.radiusMedium),
                bottomRight: Radius.circular(Dimensions.radiusMedium),
              ),
              border: Border.all(color: CustomColors.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: CustomColors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time.toReadableTime(),
                  style: const TextStyle(
                    color: CustomColors.gray,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
