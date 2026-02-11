/// Code document model
class CodeDocument {
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
  final bool isExpired;
  final DateTime? expiredDate;

  const CodeDocument({
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
    this.isExpired = false,
    this.expiredDate,
  });

  CodeDocument copyWith({
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
    bool? isExpired,
    DateTime? expiredDate,
  }) {
    return CodeDocument(
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
      isExpired: isExpired ?? this.isExpired,
      expiredDate: expiredDate ?? this.expiredDate,
    );
  }

  String? get formattedDate {
    if (date == null) return null;
    return '${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}';
  }

  String get formattedExpiredDate {
    if (expiredDate == null) return '';
    return '${expiredDate!.day.toString().padLeft(2, '0')}.${expiredDate!.month.toString().padLeft(2, '0')}.${expiredDate!.year}';
  }
}

/// Filter type for codes list
enum CodeFilter {
  all,
  favorites,
  downloaded,
}
