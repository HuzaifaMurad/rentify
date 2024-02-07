import 'dart:convert';

class Review {
  final String reviewerId;
  final double rating;
  final String comments;
  final String reviewrName;
  final String reviwerProfileUrl;

  Review({
    required this.reviewerId,
    required this.rating,
    required this.comments,
    required this.reviwerProfileUrl,
    required this.reviewrName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reviewerId': reviewerId,
      'rating': rating,
      'comments': comments,
      'reviwerProfileUrl': reviwerProfileUrl,
      'reviwerName': reviewrName
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewerId: map['reviewerId'] ?? '',
      rating: map['rating'] ?? 4.0,
      reviewrName: map['reviwerName'] ?? '',
      comments: map['comments'] ?? '',
      reviwerProfileUrl: map['reviwerProfileUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);
}
