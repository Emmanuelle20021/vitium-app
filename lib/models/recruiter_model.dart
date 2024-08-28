import 'package:vitium/models/user_model.dart';

class Recruiter extends User {
  final String company;
  final String description;

  Recruiter(
    super.id,
    super.name,
    super.image,
    super.email,
    super.phone,
    super.address,
    this.company,
    this.description,
  );

  factory Recruiter.fromJson(String id, Map<String, dynamic> json) {
    return Recruiter(
      id,
      json['name'] ?? '',
      json['image'] ?? '',
      json['email'] ?? '',
      json['phone'] ?? '',
      json['address'] ?? '',
      json['company'] ?? '',
      json['description'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'address': address,
      'company': company,
      'description': description,
    };
  }
}
