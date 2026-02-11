/// Chat thread model
class ChatThread {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;

  const ChatThread({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  ChatThread copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMessage>? messages,
  }) {
    return ChatThread(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}

/// Source document with rich metadata for Perplexity-style citations
class Source {
  final String id;  // String ID for map lookup
  final String url;
  final String domain;
  final String label;  // Short label like "lex", "xabar", "uzum"
  final String title;
  final String snippet;

  const Source({
    required this.id,
    required this.url,
    required this.domain,
    required this.label,
    required this.title,
    this.snippet = '',
  });

  factory Source.fromJson(String id, Map<String, dynamic> json) {
    return Source(
      id: id,
      url: json['url'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      label: json['label'] as String? ?? 'web',
      title: json['title'] as String? ?? '',
      snippet: json['snippet'] as String? ?? '',
    );
  }
}

/// Text block with anchor sources (Perplexity style)
/// anchorSources is ordered by relevance - first is primary (shown on chip)
class ContentBlock {
  final String text;
  final List<String> anchorSources;  // Source IDs for this paragraph

  const ContentBlock({
    required this.text,
    this.anchorSources = const [],
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      text: json['text'] as String? ?? '',
      anchorSources: (json['anchorSources'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }
  
  /// Get primary source ID (first in list, most relevant)
  String? get primarySourceId => anchorSources.isNotEmpty ? anchorSources.first : null;
  
  /// Get additional sources count (+N)
  int get additionalCount => anchorSources.length > 1 ? anchorSources.length - 1 : 0;
}

/// Chat message model with structured content blocks
class ChatMessage {
  final String id;
  final String content;  // Legacy plain text content
  final MessageRole role;
  final DateTime timestamp;
  final List<ContentBlock>? blocks;  // Structured content with citations
  final Map<String, Source>? sources;  // Source ID -> Source object
  final List<String>? relatedQuestions;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.blocks,
    this.sources,
    this.relatedQuestions,
    this.isStreaming = false,
  });

  /// Check if message has structured content
  bool get hasStructuredContent => blocks != null && blocks!.isNotEmpty;

  /// Get source by ID
  Source? getSourceById(String id) {
    return sources?[id];
  }
  
  /// Get all sources as list
  List<Source> get sourcesList => sources?.values.toList() ?? [];

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    List<ContentBlock>? blocks,
    Map<String, Source>? sources,
    List<String>? relatedQuestions,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      blocks: blocks ?? this.blocks,
      sources: sources ?? this.sources,
      relatedQuestions: relatedQuestions ?? this.relatedQuestions,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

/// Message role enum
enum MessageRole {
  user,
  assistant,
  system,
}

/// Quick action for chat
class QuickAction {
  final String id;
  final String label;
  final String prompt;

  const QuickAction({
    required this.id,
    required this.label,
    required this.prompt,
  });
}
