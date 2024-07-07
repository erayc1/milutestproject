class Post {
  final String id;
  final String date;
  final String headerText;
  final String bodyText;
  final String imageUrl;
  final String userId;

  Post({
    required this.id,
    required this.date,
    required this.headerText,
    required this.bodyText,
    required this.imageUrl,
    required this.userId,
  });

  factory Post.fromMap(Map<String, dynamic> data, String documentId) {
    return Post(
      id: documentId,
      date: data['date'] ?? '',
      headerText: data['headerText'] ?? '',
      bodyText: data['bodyText'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'headerText': headerText,
      'bodyText': bodyText,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
