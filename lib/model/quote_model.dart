class QuoteModel {
  final String id;
  final String author;
  final String content;

  QuoteModel({
    required this.id,
    required this.author,
    required this.content,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['_id'],
      author: json['author'],
      content: json['content'],
    );
  }
}
