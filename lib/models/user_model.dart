class UserModel {
  final String uid;
  final String? name;
  final String? phoneNumber;
  final String? role;

  UserModel({required this.uid,this.name, this.phoneNumber, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name:json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'phoneNumber': phoneNumber,
    'role': role,
  };
}
