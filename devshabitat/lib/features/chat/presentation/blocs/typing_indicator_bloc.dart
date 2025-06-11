import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class TypingIndicatorEvent extends Equatable {
  const TypingIndicatorEvent();

  @override
  List<Object> get props => [];
}

class TypingStatusChanged extends TypingIndicatorEvent {
  final String conversationId;
  final bool isTyping;
  final String? userId;

  const TypingStatusChanged({
    required this.conversationId,
    required this.isTyping,
    this.userId,
  });

  @override
  List<Object> get props => [conversationId, isTyping, userId ?? ''];
}

// States
abstract class TypingIndicatorState extends Equatable {
  const TypingIndicatorState();

  @override
  List<Object> get props => [];
}

class TypingIndicatorInitial extends TypingIndicatorState {}

class UserTyping extends TypingIndicatorState {
  final String userId;
  final String conversationId;

  const UserTyping({
    required this.userId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [userId, conversationId];
}

class UserStoppedTyping extends TypingIndicatorState {
  final String userId;
  final String conversationId;

  const UserStoppedTyping({
    required this.userId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [userId, conversationId];
}

// Bloc
class TypingIndicatorBloc
    extends Bloc<TypingIndicatorEvent, TypingIndicatorState> {
  TypingIndicatorBloc() : super(TypingIndicatorInitial()) {
    on<TypingStatusChanged>(_onTypingStatusChanged);
  }

  void _onTypingStatusChanged(
    TypingStatusChanged event,
    Emitter<TypingIndicatorState> emit,
  ) {
    if (event.isTyping) {
      emit(UserTyping(
        userId: event.userId ?? '',
        conversationId: event.conversationId,
      ));
    } else {
      emit(UserStoppedTyping(
        userId: event.userId ?? '',
        conversationId: event.conversationId,
      ));
    }
  }
}
