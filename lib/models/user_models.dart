import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNo;
  final String profilePic;
  final String fingerPrint;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.profilePic,
    required this.fingerPrint,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'profilePic': profilePic,
      'fingerPrint': fingerPrint,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phoneNo: map['phoneNo'] ?? "",
      profilePic: map['profilePic'] ?? "",
      fingerPrint: map['fingerPrint'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNo: $phoneNo, profilePic: $profilePic, fingerPrint: $fingerPrint)';
  }
}
