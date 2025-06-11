import 'package:injectable/injectable.dart';
import 'package:devshabitat/features/chat/domain/repositories/messaging_repository.dart';
import 'package:devshabitat/features/chat/presentation/blocs/chat_bloc.dart';
import 'package:devshabitat/features/chat/presentation/blocs/conversation_list_bloc.dart';

@module
abstract class BlocModule {
  @injectable
  ChatBloc chatBloc(MessagingRepository repository) => ChatBloc(repository);

  @injectable
  ConversationListBloc conversationListBloc(MessagingRepository repository) =>
      ConversationListBloc(repository);
}
