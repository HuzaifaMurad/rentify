// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Report {
  final String userId;
  final String reason;

  Report({required this.userId, required this.reason});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'reason': reason,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      userId: map['userId'] as String,
      reason: map['reason'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);
}
