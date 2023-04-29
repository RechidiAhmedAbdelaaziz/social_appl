class UserModel {
  late String? name;
  late String? email;
  late String? phone;
  late String? uId;
  late String? bio;
  late String? cover;
  String? image =
      'https://i.pinimg.com/564x/67/90/60/679060d15d1dbd809ff81fe1cbe60748.jpg';
  
  late bool? isEmailVerfied;
  UserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    this.image,
    this.bio,
    this.cover,
    required this.isEmailVerfied,
  });

  UserModel.fromJson(Map<String, dynamic>? json) {
    email = json?['email'];
    name = json?['name'];
    phone = json?['phone'];
    uId = json?['uId'];
    image = json?['image'];
    isEmailVerfied = json?['isEmailVerfied'];
    bio = json?['bio'];
    cover = json?['cover'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'isEmailVerfied': isEmailVerfied,
      'bio' : bio,
      'image' : image,
      'cover' : cover,

    };
  }
}
