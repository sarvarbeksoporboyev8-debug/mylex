import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../domain/chat_model.dart';

/// API response with structured blocks, sources, and related questions
class ApiResponse {
  final String answer;  // Plain text fallback
  final List<ContentBlock> blocks;  // Structured content with anchorSources
  final Map<String, Source> sources;  // Source ID -> Source object
  final List<String> relatedQuestions;
  final bool isStructured;

  ApiResponse({
    required this.answer,
    this.blocks = const [],
    this.sources = const {},
    required this.relatedQuestions,
    this.isStructured = false,
  });
}

/// LexAI API client
class LexAIApi {
  static const String baseUrl = 'https://worker-production-173b.up.railway.app';
  
  /// Extract short label from domain (e.g., lex.uz -> lex)
  static String _extractLabel(String url) {
    try {
      final uri = Uri.parse(url);
      var host = uri.host.toLowerCase();
      
      // Remove www.
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }
      
      // Remove common TLDs
      final tlds = ['.uz', '.com', '.ru', '.org', '.net', '.io', '.co'];
      for (final tld in tlds) {
        if (host.endsWith(tld)) {
          host = host.substring(0, host.length - tld.length);
          break;
        }
      }
      
      // Remove subdomains - keep main part
      final parts = host.split('.');
      if (parts.length > 1) {
        host = parts.last;
      }
      
      // Truncate if too long
      if (host.length > 10) {
        host = host.substring(0, 10);
      }
      
      return host.isNotEmpty ? host : 'web';
    } catch (_) {
      return 'web';
    }
  }
  
  static Future<ApiResponse> askQuestion(String question, {List<ChatMessage>? history}) async {
    try {
      // Build history for API
      final historyList = history?.map((msg) => {
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      }).toList() ?? [];
      
      final response = await http.post(
        Uri.parse('$baseUrl/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'history': historyList,
          'structured': true,  // Request structured response
        }),
      ).timeout(const Duration(seconds: 120));
      
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        
        // Try to parse as JSON
        try {
          final data = jsonDecode(responseBody);
          
          // Check if we got a structured response with proper blocks and sources
          // Perplexity returns structured: true with blocks and sources
          if (data is Map<String, dynamic>) {
            final isStructured = data['structured'] == true;
            final hasBlocks = data['blocks'] != null;
            final hasSources = data['sources'] != null;
            
            if (isStructured && hasBlocks && hasSources) {
              return _parseStructuredResponse(data);
            }
          }
          
          // Fallback to text parsing (handles Perplexity plain text responses)
          final answerText = data['answer'] ?? data['response'] ?? '';
          if (answerText is String && answerText.isNotEmpty) {
            return _parseLegacyResponse(answerText);
          }
        } catch (e) {
          // If JSON parsing fails, treat entire response as plain text
          print('ChatRepository: Failed to parse JSON, treating as plain text: $e');
          return _parseLegacyResponse(responseBody);
        }
        
        // Last resort: return empty response
        return ApiResponse(
          answer: 'Javob topilmadi',
          sources: {},
          relatedQuestions: [],
        );
      } else {
        return ApiResponse(
          answer: 'API xatosi: ${response.statusCode}',
          sources: {},
          relatedQuestions: [],
        );
      }
    } catch (e) {
      return ApiResponse(
        answer: 'Tarmoq xatosi: $e',
        sources: {},
        relatedQuestions: [],
      );
    }
  }
  
  /// Parse structured API response
  static ApiResponse _parseStructuredResponse(Map<String, dynamic> data) {
    // Parse blocks
    final blocksJson = data['blocks'] as List<dynamic>? ?? [];
    final blocks = blocksJson.map((b) {
      if (b is Map<String, dynamic>) {
        return ContentBlock.fromJson(b);
      }
      return ContentBlock(text: b.toString(), anchorSources: []);
    }).toList();
    
    // Parse sources (now a map: id -> source object)
    // Handle both string keys ("1", "2") and numeric keys (1, 2)
    final sourcesJson = data['sources'] as Map<String, dynamic>? ?? {};
    final sources = <String, Source>{};
    
    sourcesJson.forEach((key, sourceData) {
      if (sourceData is Map<String, dynamic>) {
        // Ensure ID is a string (handle both "1" and 1 as keys)
        final sourceId = key.toString();
        
        // Extract or compute missing fields
        final url = sourceData['url'] as String? ?? '';
        if (url.isEmpty) return; // Skip sources without URLs
        
        // Extract domain from URL if not provided
        String domain = sourceData['domain'] as String? ?? '';
        if (domain.isEmpty && url.isNotEmpty) {
          final uri = Uri.tryParse(url);
          domain = uri?.host ?? '';
        }
        
        // Extract label from domain if not provided
        String label = sourceData['label'] as String? ?? '';
        if (label.isEmpty && domain.isNotEmpty) {
          label = _extractLabel(url);
        }
        
        // Extract title, generate from URL if not provided
        String title = sourceData['title'] as String? ?? '';
        if (title.isEmpty && url.isNotEmpty) {
          final docIdMatch = RegExp(r'/docs/(-?\d+)').firstMatch(url);
          if (docIdMatch != null) {
            title = '$label hujjat #${docIdMatch.group(1)}';
          } else {
            title = '$label hujjat';
          }
        }
        
        final snippet = sourceData['snippet'] as String? ?? '';
        
        sources[sourceId] = Source(
          id: sourceId,
          url: url,
          domain: domain,
          label: label,
          title: title,
          snippet: snippet,
        );
      }
    });
    
    // Parse related questions
    final relatedJson = data['relatedQuestions'] as List<dynamic>? ?? [];
    final relatedQuestions = relatedJson
        .map((q) => q.toString().trim())
        .where((q) => q.isNotEmpty)
        .toList();
    
    // Build plain text answer from blocks for fallback
    final answerText = blocks.map((b) => b.text).join('\n\n');
    
    return ApiResponse(
      answer: answerText,
      blocks: blocks,
      sources: sources,
      relatedQuestions: relatedQuestions,
      isStructured: true,
    );
  }
  
  /// Parse legacy string response (backward compatibility)
  static ApiResponse _parseLegacyResponse(String text) {
    return _parseResponse(text);
  }

  /// Parse response to extract sources and related questions
  static ApiResponse _parseResponse(String text) {
    var answer = text;
    final sources = <String, Source>{};
    final relatedQuestions = <String>[];

    // Extract sources section - improved regex to handle Perplexity format
    // Matches: "Manbalar:" or "Sources:" followed by numbered list
    // Also handles cases where there might be extra text or formatting
    final sourcesMatch = RegExp(
      r'(?:\*\*)?(?:Manbalar|Sources|Манбалар|Источники)(?:\*\*)?:?\s*\n((?:(?:\[?\d+\]?\.?\s*)[^\n]+\n?)+)',
      caseSensitive: false,
      dotAll: true,
      multiLine: true,
    ).firstMatch(text);
    
    if (sourcesMatch != null) {
      final sourcesText = sourcesMatch.group(1) ?? '';
      
      // Improved pattern to match:
      // [1] https://url.com
      // [1] Title - https://url.com
      // [1] https://url.com (with optional title before)
      final sourcePattern = RegExp(
        r'\[(\d+)\]\s*(?:([^\n-]+?)\s*-\s*)?(https?://[^\s\n]+)',
        caseSensitive: false,
      );
      final matches = sourcePattern.allMatches(sourcesText);
      
      for (final match in matches) {
        final id = match.group(1) ?? '${sources.length + 1}';
        var title = match.group(2)?.trim() ?? '';
        final url = match.group(3)?.trim() ?? '';
        
        if (url.isNotEmpty) {
          final label = _extractLabel(url);
          final uri = Uri.tryParse(url);
          final domain = uri?.host ?? '';
          
          // Generate title from URL if not provided
          if (title.isEmpty) {
            final docIdMatch = RegExp(r'/docs/(-?\d+)').firstMatch(url);
            if (docIdMatch != null) {
              title = '$label hujjat #${docIdMatch.group(1)}';
            } else {
              // Try to extract meaningful title from URL path
              final pathParts = uri?.pathSegments.where((p) => p.isNotEmpty).toList() ?? [];
              if (pathParts.isNotEmpty) {
                title = '${pathParts.last} - $label';
              } else {
                title = '$label hujjat';
              }
            }
          }
          
          sources[id] = Source(
            id: id,
            url: url,
            domain: domain,
            label: label,
            title: title,
            snippet: '',
          );
        }
      }
      
      // Remove sources section from answer text
      answer = answer.replaceFirst(sourcesMatch.group(0) ?? '', '').trim();
    }
    
    // Also try to extract sources from inline citations in the text
    // Pattern: [1], [2], etc. followed by URLs later in the text
    if (sources.isEmpty) {
      final inlineSourcePattern = RegExp(
        r'\[(\d+)\]\s*(https?://[^\s\n\)]+)',
        caseSensitive: false,
      );
      final inlineMatches = inlineSourcePattern.allMatches(text);
      
      for (final match in inlineMatches) {
        final id = match.group(1) ?? '';
        final url = match.group(2)?.trim() ?? '';
        
        if (url.isNotEmpty && !sources.containsKey(id)) {
          final label = _extractLabel(url);
          final uri = Uri.tryParse(url);
          final domain = uri?.host ?? '';
          
          final docIdMatch = RegExp(r'/docs/(-?\d+)').firstMatch(url);
          final title = docIdMatch != null 
              ? '$label hujjat #${docIdMatch.group(1)}'
              : '$label hujjat';
          
          sources[id] = Source(
            id: id,
            url: url,
            domain: domain,
            label: label,
            title: title,
            snippet: '',
          );
        }
      }
    }

    // Extract related questions
    final questionSectionMatch = RegExp(
      r'\n+[^\n]*(?:savol|question|вопрос)[^\n]*:?\s*\n+((?:[-•*\d.]+\s*[^\n]+\n*)+)',
      caseSensitive: false,
    ).firstMatch(answer);
    
    if (questionSectionMatch != null) {
      final relatedText = questionSectionMatch.group(1) ?? '';
      final questionPattern = RegExp(r'(?:[-•*]|\d+[.\)])\s*([^\n]+)');
      
      for (final match in questionPattern.allMatches(relatedText)) {
        final question = match.group(1)?.trim() ?? '';
        if (question.isNotEmpty && relatedQuestions.length < 6) {
          var cleanQuestion = question.replaceAll('**', '').trim();
          if (cleanQuestion.endsWith('??')) {
            cleanQuestion = cleanQuestion.substring(0, cleanQuestion.length - 1);
          }
          relatedQuestions.add(cleanQuestion);
        }
      }
      
      answer = answer.substring(0, questionSectionMatch.start).trim();
    }

    // Clean up answer
    answer = answer.replaceAll(RegExp(r'\*\*\s*$'), '').trim();
    
    // Create blocks from paragraphs with anchorSources
    final blocks = <ContentBlock>[];
    final paragraphs = answer.split(RegExp(r'\n\n+'));
    final allSourceIds = sources.keys.toList();
    
    for (var i = 0; i < paragraphs.length; i++) {
      final para = paragraphs[i];
      if (para.trim().isEmpty) continue;
      
      // Find citation references [1], [2], etc. in the paragraph
      // Match both [1] and [ 1 ] formats
      final anchorSources = RegExp(r'\[(\d+)\]')
          .allMatches(para)
          .map((m) => m.group(1) ?? '')
          .where((id) => id.isNotEmpty && sources.containsKey(id))
          .toSet()
          .toList();
      
      // Debug: print if we found citations but no sources
      if (RegExp(r'\[\d+\]').hasMatch(para) && anchorSources.isEmpty && sources.isNotEmpty) {
        print('ChatRepository: Found citations in paragraph but no matching sources. Para: ${para.substring(0, para.length > 100 ? 100 : para.length)}');
        print('ChatRepository: Available source IDs: ${sources.keys.toList()}');
      }
      
      // If no citations found, distribute sources
      if (anchorSources.isEmpty && allSourceIds.isNotEmpty) {
        final sourcesPerPara = (allSourceIds.length / paragraphs.length).ceil();
        final startIdx = i * sourcesPerPara;
        final endIdx = (startIdx + sourcesPerPara).clamp(0, allSourceIds.length);
        if (startIdx < allSourceIds.length) {
          anchorSources.addAll(allSourceIds.sublist(startIdx, endIdx));
        }
      }
      
      // Clean citation markers from text
      final cleanText = para.replaceAll(RegExp(r'\s*\[\d+\]\s*'), ' ').trim();
      
      if (cleanText.isNotEmpty) {
        blocks.add(ContentBlock(text: cleanText, anchorSources: anchorSources));
      }
    }

    return ApiResponse(
      answer: answer,
      blocks: blocks,
      sources: sources,
      relatedQuestions: relatedQuestions,
      isStructured: blocks.isNotEmpty,
    );
  }
}

/// Repository for chat data
class ChatRepository {
  final _uuid = const Uuid();

  // Mock chat threads
  final List<ChatThread> _threads = [
    ChatThread(
      id: 'thread_1',
      title: 'Mehnat kodeksi haqida',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      messages: [
        ChatMessage(
          id: 'msg_1',
          content: 'Mehnat kodeksida ish vaqti qanday belgilangan?',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          id: 'msg_2',
          content: '''Mehnat kodeksiga ko'ra, normal ish vaqti haftasiga 40 soatdan oshmasligi kerak.

**Asosiy qoidalar:**

1. **Kunlik ish vaqti** - 8 soatdan oshmasligi kerak
2. **Haftalik ish vaqti** - 40 soat
3. **Qisqartirilgan ish vaqti** - 16-18 yoshli xodimlar uchun haftasiga 36 soat

**Qo'shimcha ma'lumot:**
- Tungi ish vaqti (22:00 dan 06:00 gacha) uchun qo'shimcha haq to'lanadi
- Bayram kunlari ishlash uchun ikki baravar haq to'lanadi''',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          sources: {
            '1': Source(id: '1', url: 'https://lex.uz/docs/145261', domain: 'lex.uz', label: 'lex', title: 'Mehnat kodeksi, 89-modda'),
            '2': Source(id: '2', url: 'https://lex.uz/docs/145261', domain: 'lex.uz', label: 'lex', title: 'Mehnat kodeksi, 91-modda'),
          },
          relatedQuestions: [
            'Qo\'shimcha ish vaqti qanday hisoblandi?',
            'Dam olish kunlari qanday belgilangan?',
            'Tungi ish uchun qo\'shimcha haq qancha?',
          ],
        ),
      ],
    ),
    ChatThread(
      id: 'thread_2',
      title: 'Soliq imtiyozlari',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      messages: [
        ChatMessage(
          id: 'msg_3',
          content: 'Kichik biznes uchun qanday soliq imtiyozlari bor?',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ChatMessage(
          id: 'msg_4',
          content: '''Kichik biznes subyektlari uchun quyidagi soliq imtiyozlari mavjud:

**1. Yagona soliq to'lovi:**
- Savdo va umumiy ovqatlanish - 4%
- Ishlab chiqarish - 1%
- Xizmat ko'rsatish - 4%

**2. QQS imtiyozlari:**
- Yillik aylanmasi 1 mlrd so'mdan kam bo'lgan korxonalar QQS to'lamasligi mumkin

**3. Mol-mulk solig'i:**
- Yangi tashkil etilgan korxonalar 3 yil davomida mol-mulk solig'idan ozod

**4. Yer solig'i:**
- Qishloq xo'jaligi mahsulotlari ishlab chiqaruvchilar uchun imtiyozlar''',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          sources: {
            '1': Source(id: '1', url: 'https://lex.uz/docs/4674902', domain: 'lex.uz', label: 'lex', title: 'Soliq kodeksi, 350-modda'),
            '2': Source(id: '2', url: 'https://lex.uz/docs/4674902', domain: 'lex.uz', label: 'lex', title: 'Soliq kodeksi, 355-modda'),
          },
          relatedQuestions: [
            'QQS dan qanday ozod bo\'lish mumkin?',
            'Soliq deklaratsiyasi qachon topshiriladi?',
            'IT kompaniyalar uchun qanday imtiyozlar bor?',
          ],
        ),
      ],
    ),
    ChatThread(
      id: 'thread_3',
      title: 'Nikoh to\'g\'risida',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      messages: [
        ChatMessage(
          id: 'msg_5',
          content: 'Nikohni ro\'yxatdan o\'tkazish uchun qanday hujjatlar kerak?',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ChatMessage(
          id: 'msg_6',
          content: '''Nikohni ro'yxatdan o'tkazish uchun quyidagi hujjatlar talab qilinadi:

**Asosiy hujjatlar:**
1. Pasport (asl nusxasi)
2. Tug'ilganlik haqida guvohnoma
3. Ariza (FHDYO organida to'ldiriladi)
4. Davlat boji to'langanligi haqida kvitansiya

**Qo'shimcha hujjatlar (zarur hollarda):**
- Oldingi nikoh bekor qilinganligi haqida guvohnoma
- Turmush o'rtog'ining vafot etganligi haqida guvohnoma
- Ota-onaning roziligi (18 yoshga to'lmaganlar uchun)

**Muhim:**
- Nikoh 18 yoshdan boshlab ro'yxatdan o'tkaziladi
- Alohida hollarda 17 yoshdan ruxsat berilishi mumkin''',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          sources: {
            '1': Source(id: '1', url: 'https://lex.uz/docs/104723', domain: 'lex.uz', label: 'lex', title: 'Oila kodeksi, 13-modda'),
            '2': Source(id: '2', url: 'https://lex.uz/docs/104723', domain: 'lex.uz', label: 'lex', title: 'Oila kodeksi, 15-modda'),
          },
          relatedQuestions: [
            'Nikohni bekor qilish tartibi qanday?',
            'Alimentlar qanday belgilanadi?',
            'Mol-mulkni bo\'lish qanday amalga oshiriladi?',
          ],
        ),
      ],
    ),
  ];

  // Current active thread
  String? _activeThreadId;

  /// Get all chat threads
  Future<List<ChatThread>> getThreads() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_threads)..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  /// Get threads grouped by time
  Future<Map<String, List<ChatThread>>> getGroupedThreads() async {
    final threads = await getThreads();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    final grouped = <String, List<ChatThread>>{
      'today': [],
      'thisWeek': [],
      'older': [],
    };

    for (final thread in threads) {
      final threadDate = DateTime(
        thread.updatedAt.year,
        thread.updatedAt.month,
        thread.updatedAt.day,
      );

      if (threadDate == today) {
        grouped['today']!.add(thread);
      } else if (threadDate.isAfter(weekAgo)) {
        grouped['thisWeek']!.add(thread);
      } else {
        grouped['older']!.add(thread);
      }
    }

    return grouped;
  }

  /// Get active thread
  Future<ChatThread?> getActiveThread() async {
    if (_activeThreadId == null) return null;
    try {
      return _threads.firstWhere((t) => t.id == _activeThreadId);
    } catch (_) {
      return null;
    }
  }

  /// Set active thread
  void setActiveThread(String? threadId) {
    _activeThreadId = threadId;
  }

  /// Create new thread
  Future<ChatThread> createThread() async {
    final thread = ChatThread(
      id: _uuid.v4(),
      title: 'Yangi suhbat',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
    );
    _threads.insert(0, thread);
    _activeThreadId = thread.id;
    return thread;
  }

  /// Delete thread
  Future<void> deleteThread(String threadId) async {
    _threads.removeWhere((t) => t.id == threadId);
    if (_activeThreadId == threadId) {
      _activeThreadId = _threads.isNotEmpty ? _threads.first.id : null;
    }
  }

  /// Send message and get streaming response
  Stream<ChatMessage> sendMessage(String threadId, String content) async* {
    // Add user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    if (threadIndex == -1) return;

    _threads[threadIndex] = _threads[threadIndex].copyWith(
      messages: [..._threads[threadIndex].messages, userMessage],
      updatedAt: DateTime.now(),
      title: _threads[threadIndex].messages.isEmpty
          ? content.length > 30
              ? '${content.substring(0, 30)}...'
              : content
          : _threads[threadIndex].title,
    );

    yield userMessage;

    // Show loading message
    final assistantMessageId = _uuid.v4();
    final loadingMessage = ChatMessage(
      id: assistantMessageId,
      content: 'Javob tayyorlanmoqda...',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    
    _threads[threadIndex] = _threads[threadIndex].copyWith(
      messages: [..._threads[threadIndex].messages, loadingMessage],
      updatedAt: DateTime.now(),
    );
    yield loadingMessage;

    // Call real API with chat history
    final existingMessages = _threads[threadIndex].messages;
    final apiResponse = await LexAIApi.askQuestion(content, history: existingMessages);
    
    // Stream response character by character for nice effect
    var streamedContent = '';
    for (var i = 0; i < apiResponse.answer.length; i++) {
      streamedContent += apiResponse.answer[i];
      
      final isLastChar = i >= apiResponse.answer.length - 1;
      final streamingMessage = ChatMessage(
        id: assistantMessageId,
        content: streamedContent,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        isStreaming: !isLastChar,
        blocks: isLastChar ? apiResponse.blocks : null,
        sources: isLastChar ? apiResponse.sources : null,
        relatedQuestions: isLastChar ? apiResponse.relatedQuestions : null,
      );

      // Update thread with streaming message
      final currentMessages = List<ChatMessage>.from(_threads[threadIndex].messages);
      final existingIndex = currentMessages.indexWhere((m) => m.id == assistantMessageId);
      
      if (existingIndex >= 0) {
        currentMessages[existingIndex] = streamingMessage;
      } else {
        currentMessages.add(streamingMessage);
      }

      _threads[threadIndex] = _threads[threadIndex].copyWith(
        messages: currentMessages,
        updatedAt: DateTime.now(),
      );

      yield streamingMessage;

      // Typing effect delay
      if (i % 3 == 0) {
        await Future.delayed(const Duration(milliseconds: 5));
      }
    }
  }

  String _generateMockResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('mehnat') || lowerQuery.contains('ish')) {
      return '''Mehnat qonunchiligi bo'yicha sizga yordam beraman.

**Asosiy ma'lumotlar:**

O'zbekiston Respublikasining Mehnat kodeksi mehnat munosabatlarini tartibga soladi. Kodeksda quyidagi asosiy huquqlar belgilangan:

1. **Mehnat huquqi** - har bir fuqaro erkin ravishda kasb tanlash huquqiga ega
2. **Adolatli ish haqi** - bajarilgan ish uchun adolatli haq olish
3. **Xavfsiz mehnat sharoitlari** - ish beruvchi xavfsiz sharoitlarni ta'minlashi shart

Qo'shimcha savollaringiz bo'lsa, bemalol so'rang!''';
    }

    if (lowerQuery.contains('soliq') || lowerQuery.contains('to\'lov')) {
      return '''Soliq masalalari bo'yicha ma'lumot beraman.

**Soliq turlari:**

1. **Daromad solig'i** - jismoniy shaxslar daromadidan 12%
2. **Foyda solig'i** - yuridik shaxslar foydasi uchun 15%
3. **QQS** - qo'shilgan qiymat solig'i 12%
4. **Aksiz solig'i** - ayrim tovarlar uchun

**Imtiyozlar:**
- Kichik biznes uchun soddalashtirilgan soliq tizimi
- IT kompaniyalar uchun maxsus rejim

Aniq savol bering, batafsil javob beraman!''';
    }

    if (lowerQuery.contains('nikoh') || lowerQuery.contains('oila')) {
      return '''Oila huquqi bo'yicha ma'lumot.

**Nikoh to'g'risida:**

Oila kodeksiga ko'ra, nikoh - bu er va xotinning o'zaro roziligi bilan tuziladigan ittifoqdir.

**Nikoh shartlari:**
- 18 yoshga to'lgan bo'lish
- O'zaro roziligi
- Yaqin qarindoshlar o'rtasida nikoh taqiqlangan

**Nikohni bekor qilish:**
- Sud orqali
- FHDYO organlari orqali (bolalar bo'lmasa)

Batafsil ma'lumot kerakmi?''';
    }

    return '''Savolingiz uchun rahmat! Men YuristAI yordamchisiman va O'zbekiston qonunchiligi bo'yicha yordam beraman.

**Men quyidagi sohalarda yordam bera olaman:**

1. **Fuqarolik huquqi** - shartnomalar, mulk, meros
2. **Mehnat huquqi** - ish munosabatlari, ish haqi
3. **Oila huquqi** - nikoh, ajralish, alimentlar
4. **Soliq huquqi** - soliqlar, imtiyozlar
5. **Ma'muriy huquq** - jarimalar, litsenziyalar

Aniq savol bering, batafsil javob beraman!''';
  }

  /// Get quick actions
  List<QuickAction> getQuickActions() {
    return const [
      QuickAction(
        id: 'summarize',
        label: 'Qisqartirish',
        prompt: 'Ushbu hujjatni qisqacha tushuntiring',
      ),
      QuickAction(
        id: 'find_article',
        label: 'Moddani topish',
        prompt: 'Tegishli qonun moddasini toping',
      ),
      QuickAction(
        id: 'explain_simple',
        label: 'Oddiy tilda',
        prompt: 'Oddiy tilda tushuntiring',
      ),
      QuickAction(
        id: 'draft_complaint',
        label: 'Ariza loyihasi',
        prompt: 'Ariza loyihasini tuzing',
      ),
    ];
  }
}

/// Provider for chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

/// Provider for chat threads
final chatThreadsProvider = FutureProvider<Map<String, List<ChatThread>>>(
  (ref) async {
    final repository = ref.watch(chatRepositoryProvider);
    return repository.getGroupedThreads();
  },
);

/// Provider for active thread ID
final activeThreadIdProvider = StateProvider<String?>((ref) => null);

/// Provider for active thread
final activeThreadProvider = FutureProvider<ChatThread?>((ref) async {
  final threadId = ref.watch(activeThreadIdProvider);
  if (threadId == null) return null;
  
  final repository = ref.watch(chatRepositoryProvider);
  final threads = await repository.getThreads();
  try {
    return threads.firstWhere((t) => t.id == threadId);
  } catch (_) {
    return null;
  }
});

/// Provider for quick actions
final quickActionsProvider = Provider<List<QuickAction>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getQuickActions();
});
