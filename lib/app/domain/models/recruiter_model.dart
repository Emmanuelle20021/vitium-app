import 'package:vitium/app/domain/models/user_model.dart';

class Recruiter extends User {
  final String? company;
  final String? description;

  Recruiter({
    super.id,
    super.name,
    super.image,
    super.email,
    super.phone,
    super.address,
    this.company,
    this.description,
  });

  factory Recruiter.fromJson(String id, Map<String, dynamic> json) {
    return Recruiter(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      company: json['company'] ?? '',
      description: json['description'] ?? '',
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

  @override
  bool isComplete() {
    return super.isComplete() &&
        company != null &&
        company!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty;
  }
}
