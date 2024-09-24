class User {
  final String? id;
  final String? name;
  final String? image;
  final String? email;
  final String? phone;
  final String? address;

  const User({
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.address,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  copyWith({
    String? name,
    String? image,
    String? email,
    String? phone,
    String? address,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  bool isComplete() {
    return name != null &&
        name!.isNotEmpty &&
        email != null &&
        email!.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty;
  }
}
