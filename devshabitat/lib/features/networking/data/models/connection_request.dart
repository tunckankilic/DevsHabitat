enum ConnectionStatus { pending, accepted, rejected }

enum ConnectionReason { professional, mentorship, collaboration, friendship }

class ConnectionRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String? message;
  final ConnectionReason reason;
  final ConnectionStatus status;
  final DateTime createdAt;
  final String? responseMessage;
  final DateTime? respondedAt;

  ConnectionRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.message,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.responseMessage,
    this.respondedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'reason': reason.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'responseMessage': responseMessage,
        'respondedAt': respondedAt?.toIso8601String(),
      };

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) =>
      ConnectionRequest(
        id: json['id'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        message: json['message'],
        reason: ConnectionReason.values.firstWhere(
          (e) => e.name == json['reason'],
          orElse: () => ConnectionReason.professional,
        ),
        status: ConnectionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ConnectionStatus.pending,
        ),
        createdAt: DateTime.parse(json['createdAt']),
        responseMessage: json['responseMessage'],
        respondedAt: json['respondedAt'] != null
            ? DateTime.parse(json['respondedAt'])
            : null,
      );
}
