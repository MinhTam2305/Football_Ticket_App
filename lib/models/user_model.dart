class UserModel {
  final String? uid;
  final String? name;
  final String? phoneNumber;
  final String? role;

  // final String? token;

  UserModel({this.uid, this.name, this.phoneNumber, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'],
      name: json['fullName'] ?? "Unknow",
      phoneNumber: json['phoneNumber'] ?? "Tam",
      role: json['role'] ?? "User",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': uid,
    'fullName': name,
    'phoneNumber': phoneNumber,
    'role': role,
  };
}
