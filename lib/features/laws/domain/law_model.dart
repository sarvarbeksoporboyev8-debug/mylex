/// Law document model
class LawDocument {
  final String id;
  final int index;
  final String title;
  final String issuer;
  final String docNumber;
  final DateTime? date;  // Nullable - only show if API provides actual date
  final String? summary;
  final String content;
  final bool isFavorite;
  final bool isDownloaded;
  final String? pdfUrl;
  final String? docUrl;
  final String? category;

  const LawDocument({
    required this.id,
    required this.index,
    required this.title,
    required this.issuer,
    required this.docNumber,
    this.date,
    this.summary,
    required this.content,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.pdfUrl,
    this.docUrl,
    this.category,
  });

  LawDocument copyWith({
    String? id,
    int? index,
    String? title,
    String? issuer,
    String? docNumber,
    DateTime? date,
    String? summary,
    String? content,
    bool? isFavorite,
    bool? isDownloaded,
    String? pdfUrl,
    String? docUrl,
    String? category,
  }) {
    return LawDocument(
      id: id ?? this.id,
      index: index ?? this.index,
      title: title ?? this.title,
      issuer: issuer ?? this.issuer,
      docNumber: docNumber ?? this.docNumber,
      date: date ?? this.date,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      docUrl: docUrl ?? this.docUrl,
      category: category ?? this.category,
    );
  }

  String? get formattedDate {
    if (date == null) return null;
    return '${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}';
  }
}

/// Filter type for laws list
enum LawFilter {
  all,
  favorites,
  downloaded,
}

/// Sort type for laws list
enum LawSort {
  newest,
  oldest,
  alphabetical,
}
