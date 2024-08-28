class User {
  final String id;
  final String name;
  final String image;
  final String email;
  final String phone;
  final String address;

  const User(
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.address,
  );

  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id,
      json['name'] ?? '',
      json['image'] ?? '',
      json['email'] ?? '',
      json['phone'] ?? '',
      json['address'] ?? '',
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
}
