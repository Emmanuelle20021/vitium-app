class UserModel {
  final String? id;
  final String? name;
  final String? image;
  final String? email;
  final String? phone;
  final String? role;
  final String? address;
  final List<String> disabilities;
  final String? companyCode;
  final String? cv;

  const UserModel({
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.disabilities = const [],
    this.companyCode,
    this.cv,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      disabilities: json['disabilities'] != null
          ? List<String>.from(json['disabilities'])
          : [],
      companyCode: json['companyCode'] ?? '',
      cv: json['cv'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'disabilities': disabilities,
      'companyCode': companyCode,
      'cv': cv,
    };
  }

  copyWith({
    String? id,
    String? name,
    String? image,
    String? email,
    String? phone,
    String? address,
    String? role,
    List<String>? disabilities,
    String? companyCode,
    String? cv,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
      disabilities: disabilities ?? this.disabilities,
      companyCode: companyCode ?? this.companyCode,
      cv: cv ?? this.cv,
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

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, image: $image, email: $email, phone: $phone, role: $role, address: $address, disabilities: $disabilities, companyCode: $companyCode}';
  }

  get isPostulant => role == 'postulant';
}
