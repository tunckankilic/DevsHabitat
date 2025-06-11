import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/messaging_repository.dart';

// Events
abstract class ConversationListEvent extends Equatable {
  const ConversationListEvent();

  @override
  List<Object> get props => [];
}

class LoadConversations extends ConversationListEvent {
  final String userId;

  const LoadConversations(this.userId);

  @override
  List<Object> get props => [userId];
}

class ConversationsUpdated extends ConversationListEvent {
  final List<Conversation> conversations;

  const ConversationsUpdated(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class DeleteAllConversations extends ConversationListEvent {
  final String userId;

  const DeleteAllConversations(this.userId);

  @override
  List<Object> get props => [userId];
}

// States
abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object> get props => [];
}

class ConversationListInitial extends ConversationListState {}

class ConversationListLoading extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {
  final List<Conversation> conversations;

  const ConversationListLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ConversationListError extends ConversationListState {
  final String message;

  const ConversationListError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ConversationListBloc
    extends Bloc<ConversationListEvent, ConversationListState> {
  final MessagingRepository _messagingRepository;
  StreamSubscription? _conversationsSubscription;

  ConversationListBloc(this._messagingRepository)
      : super(ConversationListInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<ConversationsUpdated>(_onConversationsUpdated);
    on<DeleteAllConversations>(_onDeleteAllConversations);
  }

  void _onLoadConversations(
      LoadConversations event, Emitter<ConversationListState> emit) async {
    emit(ConversationListLoading());

    try {
      _conversationsSubscription?.cancel();
      _conversationsSubscription = _messagingRepository
          .getConversations(event.userId)
          .listen(
            (conversations) => add(ConversationsUpdated(conversations)),
            onError: (error) => emit(ConversationListError(error.toString())),
          );
    } catch (e) {
      emit(ConversationListError(e.toString()));
    }
  }

  void _onConversationsUpdated(
      ConversationsUpdated event, Emitter<ConversationListState> emit) {
    emit(ConversationListLoaded(event.conversations));
  }

  void _onDeleteAllConversations(
      DeleteAllConversations event, Emitter<ConversationListState> emit) async {
    try {
      final conversations =
          await _messagingRepository.getConversations(event.userId).first;

      for (final conversation in conversations) {
        await _messagingRepository.deleteConversation(conversation.id);
      }
    } catch (e) {
      emit(ConversationListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _conversationsSubscription?.cancel();
    return super.close();
  }
}
