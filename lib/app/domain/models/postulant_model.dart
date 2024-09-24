import 'package:vitium/app/domain/models/user_model.dart';

class Postulant extends User {
  final List<String>? disabilities;

  Postulant({
    super.id,
    super.name,
    super.image,
    super.email,
    super.phone,
    super.address,
    this.disabilities,
  });

  factory Postulant.fromJson(String id, Map<String, dynamic> json) {
    return Postulant(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      disabilities: List<String>.from(json['disabilities']),
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

  @override
  bool isComplete() {
    return super.isComplete() &&
        disabilities != null &&
        disabilities!.isNotEmpty;
  }
}
