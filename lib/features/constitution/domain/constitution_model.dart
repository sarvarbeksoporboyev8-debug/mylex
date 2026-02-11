/// Constitution section model
class ConstitutionSection {
  final String id;
  final String title;
  final int order;
  final List<ConstitutionArticle> articles;

  const ConstitutionSection({
    required this.id,
    required this.title,
    required this.order,
    required this.articles,
  });
}

/// Constitution article model
class ConstitutionArticle {
  final String id;
  final int number;
  final String content;
  final bool isBookmarked;

  const ConstitutionArticle({
    required this.id,
    required this.number,
    required this.content,
    this.isBookmarked = false,
  });

  ConstitutionArticle copyWith({
    String? id,
    int? number,
    String? content,
    bool? isBookmarked,
  }) {
    return ConstitutionArticle(
      id: id ?? this.id,
      number: number ?? this.number,
      content: content ?? this.content,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
