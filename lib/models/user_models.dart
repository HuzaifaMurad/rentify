import 'dart:convert';

import 'package:rentify/models/report.dart';
import 'package:rentify/models/review.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNo;
  final String profilePic;
  final String fingerPrint;
  final List<String> favorite;
  List<Review>? reviews;
  final String? status;
  final List<Report>? report;
  final String? cnic;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNo,
      required this.profilePic,
      required this.fingerPrint,
      required this.favorite,
      required this.reviews,
      required this.status,
      required this.report,
      required this.cnic});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'profilePic': profilePic,
      'fingerPrint': fingerPrint,
      'favorite': favorite,
      'reviews': reviews?.map((review) => review.toMap()).toList(),
      'status': status,
      'report': report?.map((report) => report.toMap()).toList(),
      'cnic': cnic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Convert the 'favorite' field to List<String> or provide a default empty list
    List<String> favoriteList =
        (map['favorite'] as List<dynamic>?)?.cast<String>() ?? [];

// Convert the 'reviews' field to List<Review> or provide a default empty list
    List<Review> reviewList =
        (map['reviews'] as List<dynamic>?)?.map((reviewMap) {
              return Review.fromMap(reviewMap);
            }).toList() ??
            [];
    List<Report> reportList =
        (map['report'] as List<dynamic>?)?.map((reportMap) {
              return Report.fromMap(reportMap);
            }).toList() ??
            [];
    return UserModel(
      id: map['id'] as String,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phoneNo: map['phoneNo'] ?? "",
      profilePic: map['profilePic'] ?? "",
      fingerPrint: map['fingerPrint'] ?? "",
      favorite: favoriteList,
      reviews: reviewList,
      status: map['status'],
      report: reportList,
      cnic: map['cnic'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNo: $phoneNo, profilePic: $profilePic, fingerPrint: $fingerPrint, favorite: $favorite, reviews: $reviews)';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNo,
    String? profilePic,
    String? fingerPrint,
    List<String>? favorite,
    List<Review>? reviews,
    String? status,
    List<Report>? report,
    String? cnic,
  }) {
    // report: report??this.report changes done here if problem remove this.report
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNo: phoneNo ?? this.phoneNo,
        profilePic: profilePic ?? this.profilePic,
        fingerPrint: fingerPrint ?? this.fingerPrint,
        favorite: favorite ?? this.favorite,
        reviews: reviews ?? this.reviews,
        status: status ?? this.status,
        report: report ?? this.report,
        cnic: cnic ?? this.status);
  }
}
