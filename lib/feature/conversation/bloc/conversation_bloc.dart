import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:nearby_service/nearby_service.dart' as nearby;

import '../../../core/domain/entity/conversation_mesage_entity.dart';
import '../../../core/domain/service/nearby_service.dart';
import '../../../core/utils/enum/message_type_enum.dart';
import '../../../di/_dependencies.dart';
import '../../../di/shared_preferences_manager.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {

  ConversationBloc() : super(ConversationInitial()) {
    on<LoadConversationEvent>(_onLoad);
    on<SendTextMessageEvent>(_onSendText);
    on<SendAudioMessageEvent>(_onSendAudio);
    on<IncomingMessageEvent>(_onIncoming);
  }
  
  final NearbyService nearbyService = getIt();
  final SharedPreferencesManager _sharedPreferencesManager = getIt();

  final List<ConversationMessageEntity> _messages = [];

  void _onLoad(LoadConversationEvent event, Emitter<ConversationState> emit) {
    emit(ConversationLoaded(List.from(_messages)));
  }

  Future<void> _onSendText(SendTextMessageEvent event, Emitter<ConversationState> emit) async {
    final msg = ConversationMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _sharedPreferencesManager.localDeviceId,
      receiverId: _sharedPreferencesManager.lastConnectedDeviceId,
      isMe: true,
      type: MessageTypeEnum.text,
      text: event.text,
      createdAt: DateTime.now(),
    );

    _messages.add(msg);
    emit(ConversationLoaded(List.from(_messages)));

    await nearbyService.send(nearby.NearbyMessageTextRequest.create(value: event.text));
  }

  Future<void> _onSendAudio(SendAudioMessageEvent event, Emitter<ConversationState> emit) async {
    final msg = ConversationMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _sharedPreferencesManager.localDeviceId,
      receiverId: _sharedPreferencesManager.lastConnectedDeviceId,
      isMe: true,
      type: MessageTypeEnum.audio,
      filePath: event.audioFile.path,
      createdAt: DateTime.now(),
    );

    _messages.add(msg);
    emit(ConversationLoaded(List.from(_messages)));

    final fileInfo = nearby.NearbyFileInfo(path: event.audioFile.path);

    await nearbyService.send(nearby.NearbyMessageFilesRequest.create(files: [fileInfo]),
    );
  }

  void _onIncoming(IncomingMessageEvent event, Emitter<ConversationState> emit) {
    _messages.add(event.message);
    emit(ConversationLoaded(List.from(_messages)));
  }
}
