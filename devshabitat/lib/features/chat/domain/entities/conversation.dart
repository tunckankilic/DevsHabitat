import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

enum ConversationType {
  direct,
  group,
}

class Conversation extends Equatable {
  final String id;
  final List<String> participantIds;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final Map<String, DateTime> lastReadBy;
  final bool isGroup;
  final String? groupName;
  final String? groupImage;
  final List<String>? groupAdmins;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ConversationType type;
  final String? lastMessage;
  final Map<String, int> unreadCounts;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageTime,
    required this.lastReadBy,
    required this.isGroup,
    this.groupName,
    this.groupImage,
    this.groupAdmins,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.lastMessage,
    required this.unreadCounts,
  });

  factory Conversation.fromFirestore(Map<String, dynamic> doc) {
    return Conversation(
      id: doc['id'] as String,
      participantIds: List<String>.from(doc['participantIds'] as List),
      lastMessageId: doc['lastMessageId'] as String?,
      lastMessageTime: (doc['lastMessageTime'] as Timestamp?)?.toDate(),
      lastReadBy: Map<String, DateTime>.from(
        (doc['lastReadBy'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as Timestamp).toDate()),
        ),
      ),
      isGroup: doc['isGroup'] as bool,
      groupName: doc['groupName'] as String?,
      groupImage: doc['groupImage'] as String?,
      groupAdmins: doc['groupAdmins'] != null
          ? List<String>.from(doc['groupAdmins'] as List)
          : null,
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
      type: doc['isGroup'] as bool
          ? ConversationType.group
          : ConversationType.direct,
      lastMessage: doc['lastMessage'] as String?,
      unreadCounts: Map<String, int>.from(doc['unreadCounts'] as Map),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageTime': lastMessageTime,
      'lastReadBy': lastReadBy.map(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),
      'isGroup': isGroup,
      'groupName': groupName,
      'groupImage': groupImage,
      'groupAdmins': groupAdmins,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
      'unreadCounts': unreadCounts,
    };
  }

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessageId,
    DateTime? lastMessageTime,
    Map<String, DateTime>? lastReadBy,
    bool? isGroup,
    String? groupName,
    String? groupImage,
    List<String>? groupAdmins,
    DateTime? createdAt,
    DateTime? updatedAt,
    ConversationType? type,
    String? lastMessage,
    Map<String, int>? unreadCounts,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastReadBy: lastReadBy ?? this.lastReadBy,
      isGroup: isGroup ?? this.isGroup,
      groupName: groupName ?? this.groupName,
      groupImage: groupImage ?? this.groupImage,
      groupAdmins: groupAdmins ?? this.groupAdmins,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCounts: unreadCounts ?? this.unreadCounts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        participantIds,
        lastMessageId,
        lastMessageTime,
        lastReadBy,
        isGroup,
        groupName,
        groupImage,
        groupAdmins,
        createdAt,
        updatedAt,
        type,
        lastMessage,
        unreadCounts,
      ];
}
