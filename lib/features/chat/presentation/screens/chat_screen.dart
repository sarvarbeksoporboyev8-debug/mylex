import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';
import '../widgets/citation_pill.dart';

/// State provider for messages in current chat
final chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) => []);

/// State provider for streaming status
final isStreamingProvider = StateProvider<bool>((ref) => false);

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  StreamSubscription? _streamSubscription;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final repository = ref.read(chatRepositoryProvider);
    var threadId = ref.read(activeThreadIdProvider);

    // Create new thread if none active
    if (threadId == null) {
      final thread = await repository.createThread();
      threadId = thread.id;
      ref.read(activeThreadIdProvider.notifier).state = threadId;
    }

    _messageController.clear();
    ref.read(isStreamingProvider.notifier).state = true;

    // Listen to streaming response
    _streamSubscription?.cancel();
    _streamSubscription = repository.sendMessage(threadId, content).listen(
      (message) {
        final messages = ref.read(chatMessagesProvider);
        final existingIndex = messages.indexWhere((m) => m.id == message.id);

        if (existingIndex >= 0) {
          messages[existingIndex] = message;
          ref.read(chatMessagesProvider.notifier).state = List.from(messages);
        } else {
          ref.read(chatMessagesProvider.notifier).state = [...messages, message];
        }

        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      },
      onDone: () {
        ref.read(isStreamingProvider.notifier).state = false;
        ref.invalidate(chatThreadsProvider);
      },
      onError: (error) {
        ref.read(isStreamingProvider.notifier).state = false;
        final strings = ref.read(stringsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${strings.error}: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  void _onQuickAction(QuickAction action) {
    _sendMessage(action.prompt);
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  Future<void> _startNewChat() async {
    final repository = ref.read(chatRepositoryProvider);
    final thread = await repository.createThread();
    ref.read(activeThreadIdProvider.notifier).state = thread.id;
    ref.read(chatMessagesProvider.notifier).state = [];
    ref.invalidate(chatThreadsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final messages = ref.watch(chatMessagesProvider);
    final isStreaming = ref.watch(isStreamingProvider);
    final quickActions = ref.watch(quickActionsProvider);
    final activeThreadId = ref.watch(activeThreadIdProvider);

    // Load messages when thread changes
    ref.listen(activeThreadIdProvider, (previous, next) async {
      if (next != null && next != previous) {
        final repository = ref.read(chatRepositoryProvider);
        final threads = await repository.getThreads();
        try {
          final thread = threads.firstWhere((t) => t.id == next);
          ref.read(chatMessagesProvider.notifier).state = thread.messages;
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        } catch (_) {}
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.s,
              ),
              child: SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Left actions (history)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(
                        builder: (context) => GlassIconButton(
                          icon: PhosphorIconsRegular.slidersHorizontal,
                          onPressed: () => context.push(AppRoutes.chatHistory),
                        ),
                      ),
                    ),
                    // Perfectly centered logo (independent of side actions)
                    Center(
                      child: Image.asset(
                        'assets/images/yurist_ai_logo.png',
                        height: 32,
                      ),
                    ),
                    // Right actions (settings + new chat)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GlassIconButton(
                            icon: PhosphorIconsRegular.gearSix,
                            onPressed: () => context.push(AppRoutes.settings),
                          ),
                          AppSpacing.gapHorizontalS,
                          GlassIconButton(
                            icon: PhosphorIconsRegular.plus,
                            onPressed: _startNewChat,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Messages
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState(quickActions)
                  : _buildMessagesList(messages),
            ),

            // Input area
            _buildInputArea(isStreaming, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<QuickAction> quickActions) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo - bigger icon
            Image.asset(
              'assets/images/nav/chat.png',
              width: 120,
              height: 120,
              color: AppColors.primary,
              colorBlendMode: BlendMode.srcIn,
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 300.ms),

            const SizedBox(height: 24),

            Consumer(
              builder: (context, ref, _) {
                final strings = ref.watch(stringsProvider);
                return Text(
                  strings.chatGreeting,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 12),

            Consumer(
              builder: (context, ref, _) {
                final strings = ref.watch(stringsProvider);
                return Text(
                  strings.chatDescription,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(String actionId) {
    switch (actionId) {
      case 'summarize':
        return PhosphorIconsRegular.textAlignLeft;
      case 'find_article':
        return PhosphorIconsRegular.magnifyingGlass;
      case 'explain_simple':
        return PhosphorIconsRegular.lightbulb;
      case 'draft_complaint':
        return PhosphorIconsRegular.fileText;
      default:
        return PhosphorIconsRegular.sparkle;
    }
  }

  Widget _buildMessagesList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: AppSpacing.m,
        bottom: AppSpacing.m,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _MessageBubble(
          message: message,
          animationIndex: index,
          onRelatedQuestionTap: (question) {
            _sendMessage(question);
          },
        );
      },
    );
  }

  Widget _buildInputArea(bool isStreaming, AppStrings strings) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 110,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: isStreaming ? null : _sendMessage,
                decoration: InputDecoration(
                  hintText: strings.typeMessage,
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: isStreaming
                  ? null
                  : () => _sendMessage(_messageController.text),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: isStreaming
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.textTertiary,
                          ),
                        ),
                      )
                    : Icon(
                        PhosphorIconsRegular.paperPlaneTilt,
                        size: 22,
                        color: AppColors.accent,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Message bubble widget - Perplexity style
class _MessageBubble extends ConsumerWidget {
  final ChatMessage message;
  final int animationIndex;
  final Function(String)? onRelatedQuestionTap;

  const _MessageBubble({
    required this.message,
    this.animationIndex = 0,
    this.onRelatedQuestionTap,
  });

  void _openUrl(String url) async {
    // Use url_launcher or in-app browser
    // For now, we'll handle this in the parent
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 60 : AppSpacing.m,
        right: isUser ? AppSpacing.m : 60,
        bottom: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: isUser ? AppColors.userBubble : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content
                if (isUser)
                  Text(
                    message.content,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                else if (message.hasStructuredContent && !message.isStreaming)
                  // Render blocks with inline citation pills
                  _buildBlocksWithCitations(message)
                else
                  MarkdownBody(
                    data: message.content,
                    styleSheet: MarkdownStyleSheet(
                      p: AppTypography.bodyMedium.copyWith(
                        height: 1.6,
                        color: AppColors.textPrimary,
                      ),
                      strong: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      h1: AppTypography.titleLarge,
                      h2: AppTypography.titleMedium,
                      h3: AppTypography.titleSmall,
                      listBullet: AppTypography.bodyMedium,
                      listIndent: 20,
                      pPadding: const EdgeInsets.only(bottom: 12),
                    ),
                    selectable: true,
                  ),

                // Streaming indicator
                if (message.isStreaming) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.accent),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        strings.typing,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                
                // Sources section at bottom (Perplexity style)
                if (!isUser && message.sources != null && message.sources!.isNotEmpty && !message.isStreaming)
                  SourcesSection(sources: message.sources!),
              ],
            ),
          ),

          // Related Questions - Perplexity style
          if (!isUser && message.relatedQuestions != null && message.relatedQuestions!.isNotEmpty && !message.isStreaming) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.lightbulb,
                        size: 18,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tegishli savollar',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...message.relatedQuestions!.map((question) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => onRelatedQuestionTap?.call(question),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                question,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              PhosphorIconsRegular.arrowRight,
                              size: 18,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
        .slideX(
          begin: isUser ? 0.1 : -0.1,
          end: 0,
          duration: 200.ms,
          curve: Curves.easeOutCubic,
        );
  }

  void _launchUrl(BuildContext context, String url) {
    // Navigate to document details or open in browser
    context.push(
      AppRoutes.newsDetails,
      extra: {'title': 'Hujjat', 'url': url},
    );
  }

  /// Build content blocks with inline citation pills (Perplexity style)
  Widget _buildBlocksWithCitations(ChatMessage message) {
    final blocks = message.blocks ?? [];
    final sources = message.sources ?? {};
    
    if (blocks.isEmpty) {
      return Text(
        message.content,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          height: 1.6,
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        // Build text with inline citation pill
        final List<InlineSpan> spans = [];
        
        // Add the main text
        spans.add(TextSpan(
          text: block.text,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ));
        
        // Add single citation pill showing "label +N" format
        if (block.anchorSources.isNotEmpty) {
          // Get all sources for this anchor
          final anchorSourcesList = block.anchorSources
              .map((id) => sources[id])
              .whereType<Source>()
              .toList();
          
          if (anchorSourcesList.isNotEmpty) {
            final primarySource = anchorSourcesList.first;
            final additionalCount = anchorSourcesList.length - 1;
            
            spans.add(WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: CitationPill(
                primaryLabel: primarySource.label,
                additionalCount: additionalCount,
                anchorSources: anchorSourcesList,
              ),
            ));
          }
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(children: spans),
          ),
        );
      }).toList(),
    );
  }
}
