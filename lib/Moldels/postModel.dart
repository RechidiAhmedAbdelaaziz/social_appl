// ignore_for_file: file_names

class PostModel {
  late String? name;
  late String? uId;
  late String? id;
  late String? image;
  late String? dateTime;
  late String? text;
  late String? tags;
  late String? postImage;
  late int likes = 0;
  late List<dynamic>? comments = [];

  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    this.tags,
    this.dateTime,
    this.postImage,
    this.text,
    this.id,
    this.likes = 0,
    this.comments = const [],
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json?['name'];
    uId = json?['uId'];
    id = json?['id'];
    dateTime = json?['dateTime'];
    text = json?['text'];
    tags = json?['tags'];
    postImage = json?['postImage'];
    image = json?['image'];
    likes = json?['likes'];
    comments = json?['comments'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'postImage': postImage,
      'text': text,
      'tags': tags,
      'id': id,
      'likes': likes,
      'comments' : comments
    };
  }
}
