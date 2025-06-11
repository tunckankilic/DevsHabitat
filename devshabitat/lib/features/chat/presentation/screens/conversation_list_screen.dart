import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/conversation.dart';
import '../blocs/conversation_list_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationListScreen extends StatelessWidget {
  ConversationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationListBloc(
        context.read(),
      )..add(LoadConversations(FirebaseAuth.instance.currentUser?.uid ?? '')),
      child: Scaffold(
        backgroundColor: DevHabitatColors.darkBackground,
        appBar: AppBar(
          backgroundColor: DevHabitatColors.darkSurface,
          title: Text(
            'Mesajlar',
            style: DevHabitatTheme.titleLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showMoreOptions(context),
            ),
          ],
        ),
        body: BlocBuilder<ConversationListBloc, ConversationListState>(
          builder: (context, state) {
            if (state is ConversationListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ConversationListError) {
              return Center(
                child: Text(
                  state.message,
                  style: DevHabitatTheme.bodyMedium.copyWith(
                    color: DevHabitatColors.error,
                  ),
                ),
              );
            }

            if (state is ConversationListLoaded) {
              if (state.conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: DevHabitatColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz mesajınız yok',
                        style: DevHabitatTheme.titleMedium.copyWith(
                          color: DevHabitatColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yeni bir sohbet başlatmak için + butonuna tıklayın',
                        style: DevHabitatTheme.bodyMedium.copyWith(
                          color: DevHabitatColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  return _ConversationTile(conversation: conversation);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNewConversationDialog(context),
          backgroundColor: DevHabitatColors.primaryBlue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DevHabitatColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yeni Sohbet',
              style: DevHabitatTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              style: DevHabitatTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Kullanıcı ara...',
                hintStyle: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: DevHabitatColors.textSecondary,
                ),
                filled: true,
                fillColor: DevHabitatColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _mockUsers.length,
                itemBuilder: (context, index) {
                  final user = _mockUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: DevHabitatColors.primaryBlue,
                      child: Text(
                        user['name']![0].toUpperCase(),
                        style: DevHabitatTheme.labelMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      user['name']!,
                      style: DevHabitatTheme.titleMedium,
                    ),
                    subtitle: Text(
                      user['email']!,
                      style: DevHabitatTheme.bodySmall.copyWith(
                        color: DevHabitatColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/chat/${user['id']}', extra: {
                        'participantName': user['name'],
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DevHabitatColors.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mesajlarda Ara',
              style: DevHabitatTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              style: DevHabitatTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Mesaj ara...',
                hintStyle: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: DevHabitatColors.textSecondary,
                ),
                filled: true,
                fillColor: DevHabitatColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _mockSearchResults.length,
                itemBuilder: (context, index) {
                  final result = _mockSearchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: DevHabitatColors.primaryBlue,
                      child: Text(
                        result['name']![0].toUpperCase(),
                        style: DevHabitatTheme.labelMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      result['name']!,
                      style: DevHabitatTheme.titleMedium,
                    ),
                    subtitle: Text(
                      result['message']!,
                      style: DevHabitatTheme.bodySmall.copyWith(
                        color: DevHabitatColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/chat/${result['id']}', extra: {
                        'participantName': result['name'],
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DevHabitatColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: DevHabitatColors.textPrimary,
              ),
              title: Text(
                'Bildirim Ayarları',
                style: DevHabitatTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings/notifications');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.block,
                color: DevHabitatColors.textPrimary,
              ),
              title: Text(
                'Engellenen Kullanıcılar',
                style: DevHabitatTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings/blocked-users');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: DevHabitatColors.error,
              ),
              title: Text(
                'Tüm Sohbetleri Temizle',
                style: DevHabitatTheme.titleMedium.copyWith(
                  color: DevHabitatColors.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tüm Sohbetleri Temizle'),
                    content: const Text(
                        'Tüm sohbetlerinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            context.read<ConversationListBloc>().add(
                                  DeleteAllConversations(currentUser.uid),
                                );
                          }
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: DevHabitatColors.error,
                        ),
                        child: const Text('Sil'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Mock data
  final List<Map<String, String>> _mockUsers = [
    {
      'name': 'Ahmet Yılmaz',
      'email': 'ahmet@example.com',
    },
    {
      'name': 'Ayşe Demir',
      'email': 'ayse@example.com',
    },
    {
      'name': 'Mehmet Kaya',
      'email': 'mehmet@example.com',
    },
  ];

  final List<Map<String, String>> _mockSearchResults = [
    {
      'name': 'Ahmet Yılmaz',
      'message': 'Merhaba, nasılsın?',
    },
    {
      'name': 'Ayşe Demir',
      'message': 'Projeyi ne zaman bitireceğiz?',
    },
    {
      'name': 'Mehmet Kaya',
      'message': 'Toplantı saat 14:00\'te başlayacak.',
    },
  ];
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const _ConversationTile({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: DevHabitatColors.primaryBlue,
        child: Text(
          conversation.type == ConversationType.direct
              ? conversation.participantIds.first[0].toUpperCase()
              : conversation.groupName?[0].toUpperCase() ?? 'G',
          style: DevHabitatTheme.titleMedium.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        conversation.type == ConversationType.direct
            ? conversation.participantIds.first
            : conversation.groupName ?? 'Grup Sohbeti',
        style: DevHabitatTheme.titleMedium,
      ),
      subtitle: Text(
        conversation.lastMessage ?? 'Henüz mesaj yok',
        style: DevHabitatTheme.bodySmall.copyWith(
          color: DevHabitatColors.textSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(conversation.updatedAt),
            style: DevHabitatTheme.labelSmall.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
          ),
          if ((conversation
                      .unreadCounts[FirebaseAuth.instance.currentUser?.uid] ??
                  0) >
              0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: DevHabitatColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                conversation
                    .unreadCounts[FirebaseAuth.instance.currentUser?.uid]
                    .toString(),
                style: DevHabitatTheme.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        context.push('/chat/${conversation.id}', extra: {
          'participantName': conversation.type == ConversationType.direct
              ? conversation.participantIds.first
              : conversation.groupName ?? 'Grup Sohbeti',
        });
      },
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
