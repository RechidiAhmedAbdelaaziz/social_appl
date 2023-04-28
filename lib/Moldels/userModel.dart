class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late bool isEmailVerfied;
  UserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.isEmailVerfied,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    isEmailVerfied = json['isEmailVerfied'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'isEmailVerfied': isEmailVerfied,
    };
  }
}
