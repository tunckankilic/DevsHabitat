import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/message.dart';

class MessageSearchResult {
  final String messageId;
  final String senderId;
  final String content;
  final MessageType messageType;
  final DateTime timestamp;

  const MessageSearchResult({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.timestamp,
  });
}

class MessageSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _cacheKey = 'message_search_cache';
  static const Duration cacheDuration = Duration(hours: 24);

  Future<List<MessageSearchResult>> searchMessages({
    required String conversationId,
    required String query,
  }) async {
    try {
      final messagesRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages');

      final querySnapshot = await messagesRef
          .where('content', isGreaterThanOrEqualTo: query)
          .where('content', isLessThanOrEqualTo: query + '\uf8ff')
          .orderBy('content')
          .limit(20)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MessageSearchResult(
          messageId: doc.id,
          senderId: data['senderId'] as String,
          content: data['content'] as String,
          messageType: MessageType.values.firstWhere(
            (type) => type.toString() == data['type'],
            orElse: () => MessageType.text,
          ),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error searching messages: $e');
      rethrow;
    }
  }

  Future<List<SearchResult>> _searchFirestore({
    required String conversationId,
    required String query,
    MessageType? messageType,
    DateTime? startDate,
    DateTime? endDate,
    String? senderId,
  }) async {
    Query messagesQuery = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');

    // Add filters
    if (messageType != null) {
      messagesQuery = messagesQuery.where('type', isEqualTo: messageType.name);
    }

    if (senderId != null) {
      messagesQuery = messagesQuery.where('senderId', isEqualTo: senderId);
    }

    if (startDate != null) {
      messagesQuery =
          messagesQuery.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      messagesQuery =
          messagesQuery.where('timestamp', isLessThanOrEqualTo: endDate);
    }

    // Text search using array-contains for tokenized keywords
    final keywords = _tokenizeQuery(query);
    if (keywords.isNotEmpty) {
      messagesQuery =
          messagesQuery.where('searchKeywords', arrayContainsAny: keywords);
    }

    messagesQuery =
        messagesQuery.orderBy('timestamp', descending: true).limit(50);

    final snapshot = await messagesQuery.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SearchResult(
        messageId: doc.id,
        content: data['content'] ?? '',
        senderId: data['senderId'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        messageType: MessageType.values.firstWhere(
          (type) => type.name == data['type'],
          orElse: () => MessageType.text,
        ),
        relevanceScore: _calculateRelevanceScore(data['content'] ?? '', query),
      );
    }).toList();
  }

  List<String> _tokenizeQuery(String query) {
    return query
        .toLowerCase()
        .split(RegExp(r'[\s\+\-\(\)\"]+'))
        .where((word) => word.length > 2)
        .toList();
  }

  double _calculateRelevanceScore(String content, String query) {
    final contentLower = content.toLowerCase();
    final queryLower = query.toLowerCase();

    // Exact match bonus
    if (contentLower.contains(queryLower)) {
      return 1.0;
    }

    // Word match scoring
    final queryWords = queryLower.split(' ');
    final contentWords = contentLower.split(' ');

    int matches = 0;
    for (final queryWord in queryWords) {
      if (contentWords.any((word) => word.contains(queryWord))) {
        matches++;
      }
    }

    return matches / queryWords.length;
  }

  Future<List<SearchResult>> _searchCache(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cacheKey}_${query.hashCode}';
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final Map<String, dynamic> cache = jsonDecode(cachedData);
        final cacheTime = DateTime.parse(cache['timestamp']);

        if (_isCacheValid(cacheTime)) {
          final List<dynamic> results = cache['results'];
          return results.map((item) => SearchResult.fromJson(item)).toList();
        }
      }
    } catch (e) {
      // Cache read failed, continue with Firestore search
    }
    return [];
  }

  bool _isCacheValid(DateTime cacheTime) {
    return DateTime.now().difference(cacheTime) < cacheDuration;
  }

  Future<void> _updateCache(String query, List<SearchResult> results) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '${_cacheKey}_${query.hashCode}';
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'results': results.map((result) => result.toJson()).toList(),
      };
      await prefs.setString(cacheKey, jsonEncode(cacheData));
    } catch (e) {
      // Cache write failed, not critical
    }
  }

  List<SearchResult> _mergeResults(
      List<SearchResult> cached, List<SearchResult> firestore) {
    final Map<String, SearchResult> merged = {};

    // Add Firestore results (more recent)
    for (final result in firestore) {
      merged[result.messageId] = result;
    }

    // Add cached results if not already present
    for (final result in cached) {
      if (!merged.containsKey(result.messageId)) {
        merged[result.messageId] = result;
      }
    }

    // Sort by relevance and timestamp
    final results = merged.values.toList();
    results.sort((a, b) {
      final scoreComparison = b.relevanceScore.compareTo(a.relevanceScore);
      if (scoreComparison != 0) return scoreComparison;
      return b.timestamp.compareTo(a.timestamp);
    });

    return results;
  }
}

class SearchResult {
  final String messageId;
  final String content;
  final String senderId;
  final DateTime timestamp;
  final MessageType messageType;
  final double relevanceScore;

  SearchResult({
    required this.messageId,
    required this.content,
    required this.senderId,
    required this.timestamp,
    required this.messageType,
    required this.relevanceScore,
  });

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'content': content,
        'senderId': senderId,
        'timestamp': timestamp.toIso8601String(),
        'messageType': messageType.name,
        'relevanceScore': relevanceScore,
      };

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        messageId: json['messageId'],
        content: json['content'],
        senderId: json['senderId'],
        timestamp: DateTime.parse(json['timestamp']),
        messageType: MessageType.values
            .firstWhere((type) => type.name == json['messageType']),
        relevanceScore: json['relevanceScore'],
      );
}

class SearchException implements Exception {
  final String message;
  SearchException(this.message);

  @override
  String toString() => 'SearchException: $message';
}

enum MessageType { text, image, file, audio, video, location }
