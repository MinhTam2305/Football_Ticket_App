class UserModel {
  final String uid;
  final String? phoneNumber;
  final String? role;

  UserModel({required this.uid, this.phoneNumber, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'phoneNumber': phoneNumber,
    'role': role,
  };
}
