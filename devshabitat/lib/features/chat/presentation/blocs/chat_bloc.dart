import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messaging_repository.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String conversationId;
  const LoadMessages(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}

class SendMessage extends ChatEvent {
  final Message message;
  const SendMessage(this.message);
  @override
  List<Object> get props => [message];
}

class MessagesUpdated extends ChatEvent {
  final List<Message> messages;
  const MessagesUpdated(this.messages);
  @override
  List<Object> get props => [messages];
}

class BlockUser extends ChatEvent {
  final String userId;
  final String blockedUserId;
  const BlockUser(this.userId, this.blockedUserId);
  @override
  List<Object> get props => [userId, blockedUserId];
}

class DeleteConversation extends ChatEvent {
  final String conversationId;
  const DeleteConversation(this.conversationId);
  @override
  List<Object> get props => [conversationId];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  const ChatLoaded(this.messages);
  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessagingRepository _messagingRepository;
  StreamSubscription? _messagesSubscription;

  ChatBloc(this._messagingRepository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<BlockUser>(_onBlockUser);
    on<DeleteConversation>(_onDeleteConversation);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      _messagesSubscription?.cancel();
      _messagesSubscription =
          _messagingRepository.getMessages(event.conversationId).listen(
                (messages) => add(MessagesUpdated(messages)),
                onError: (error) => emit(ChatError(error.toString())),
              );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _messagingRepository.sendMessage(event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  void _onBlockUser(BlockUser event, Emitter<ChatState> emit) async {
    try {
      await _messagingRepository.blockUser(event.userId, event.blockedUserId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onDeleteConversation(
      DeleteConversation event, Emitter<ChatState> emit) async {
    try {
      await _messagingRepository.deleteConversation(event.conversationId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
