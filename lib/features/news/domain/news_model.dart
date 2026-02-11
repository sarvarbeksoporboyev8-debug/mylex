/// News article model
class NewsArticle {
  final String id;
  final String title;
  final String? summary;
  final String content;
  final DateTime date;
  final String category;
  final String? imageUrl;
  final String? relatedLawId;
  final String? pdfUrl;
  final String? docUrl;
  final bool isNew;

  const NewsArticle({
    required this.id,
    required this.title,
    this.summary,
    required this.content,
    required this.date,
    required this.category,
    this.imageUrl,
    this.relatedLawId,
    this.pdfUrl,
    this.docUrl,
    this.isNew = false,
  });

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String get fullFormattedDate {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  NewsArticle copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    DateTime? date,
    String? category,
    String? imageUrl,
    String? relatedLawId,
    String? pdfUrl,
    String? docUrl,
    bool? isNew,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      date: date ?? this.date,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      relatedLawId: relatedLawId ?? this.relatedLawId,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      docUrl: docUrl ?? this.docUrl,
      isNew: isNew ?? this.isNew,
    );
  }
}
