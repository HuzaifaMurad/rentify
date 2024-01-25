// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String? id;
  final String? title;
  final String? description;
  final double price;
  final List<String> images; // URLs or paths to product images
  final String? category;
  final bool? isAvailable;
  final String? postedDate;
  final String? location;
  final String? address;
  final String? ownerId;
  final String? ownerName;
  final String? ownerContact;

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
    };
  }

  // Create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      images: List<String>.from(map['images']),
      category: map['category'],
      isAvailable: map['isAvailable'],
      postedDate: map['postedDate'],
      location: map['location'],
      address: map['address'],
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      ownerContact: map['ownerContact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, images: $images, category: $category, isAvailable: $isAvailable, postedDate: $postedDate, location: $location, address: $address, ownerId: $ownerId, ownerName: $ownerName, ownerContact: $ownerContact)';
  }
}
