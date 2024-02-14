// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/models/report.dart';

class Product {
  final String? id;
  final String? title;
  final String? description;
  final double price;
  final List<String> images; // URLs or paths to product images
  final String? category;
  bool? isAvailable;
  final DateTime? postedDate;
  final String? location;
  final String? address;
  final String? ownerId;
  final String? ownerName;
  final String? ownerContact;
  final String? status;
  final int? reports;
  final List<Report>? report;
  final List<String>? view;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.isAvailable,
    required this.postedDate,
    required this.location,
    required this.address,
    required this.ownerId,
    required this.ownerName,
    required this.ownerContact,
    required this.status,
    required this.reports,
    required this.report,
    required this.view,
  });

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'isAvailable': isAvailable,
      'postedDate': postedDate,
      'location': location,
      'address': address,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'reports': reports,
      'status': status,
      'report': report?.map((report) => report.toMap()).toList(),
      'view': view,
    };
  }

  // Create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    List<Report> reviewList =
        (map['report'] as List<dynamic>?)?.map((reportMap) {
              return Report.fromMap(reportMap);
            }).toList() ??
            [];
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      images: List<String>.from(map['images']),
      category: map['category'],
      isAvailable: map['isAvailable'],
      postedDate: (map['postedDate'] as Timestamp).toDate(),
      location: map['location'],
      address: map['address'],
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      ownerContact: map['ownerContact'],
      reports: map['reports'],
      status: map['status'],
      report: reviewList,
      view: List<String>.from(map['view']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, images: $images, category: $category, isAvailable: $isAvailable, postedDate: $postedDate, location: $location, address: $address, ownerId: $ownerId, ownerName: $ownerName, ownerContact: $ownerContact)';
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    List<String>? images,
    String? category,
    bool? isAvailable,
    DateTime? postedDate,
    String? location,
    String? address,
    String? ownerId,
    String? ownerName,
    String? ownerContact,
    int? reports,
    String? status,
    List<Report>? report,
    List<String>? view,
  }) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        images: images ?? this.images,
        category: category ?? this.category,
        isAvailable: isAvailable ?? this.isAvailable,
        postedDate: postedDate ?? this.postedDate,
        location: location ?? this.location,
        address: address ?? this.address,
        ownerId: ownerId ?? this.ownerId,
        ownerName: ownerName ?? this.ownerName,
        ownerContact: ownerContact ?? this.ownerContact,
        reports: reports ?? this.reports,
        status: status ?? this.status,
        view: view,
        report: report);
  }
}
