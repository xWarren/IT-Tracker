import 'package:bloc/bloc.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {

  ConversationBloc() : super(InitialState()) {
    on<DoGetConversationEvent>(_doGetConversation);
  }

  void _doGetConversation(DoGetConversationEvent event, Emitter<ConversationState> emit) {

  }
}