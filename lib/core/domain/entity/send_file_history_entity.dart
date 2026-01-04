class SentFileHistoryEntity {
  final String fileName;
  final String path;
  final int size;
  final DateTime sentAt;

  SentFileHistoryEntity({
    required this.fileName,
    required this.path,
    required this.size,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'path': path,
    'size': size,
    'sentAt': sentAt.toIso8601String(),
  };

  factory SentFileHistoryEntity.fromJson(Map<String, dynamic> json) {
    return SentFileHistoryEntity(
      fileName: json['fileName'],
      path: json['path'],
      size: json['size'],
      sentAt: DateTime.parse(json['sentAt']),
    );
  }
}
