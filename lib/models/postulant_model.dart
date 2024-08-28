import 'package:vitium/models/user_model.dart';

class Postulant extends User {
  final List<String> disabilities;

  Postulant(
    super.id,
    super.name,
    super.image,
    super.email,
    super.phone,
    super.address,
    this.disabilities,
  );

  factory Postulant.fromJson(String id, Map<String, dynamic> json) {
    return Postulant(
      id,
      json['name'] ?? '',
      json['image'] ?? '',
      json['email'] ?? '',
      json['phone'] ?? '',
      json['address'] ?? '',
      List<String>.from(json['disabilities']),
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
      'disabilities': disabilities,
    };
  }
}
