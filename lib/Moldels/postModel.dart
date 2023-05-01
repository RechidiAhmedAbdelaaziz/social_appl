class PostModel {
  late String? name;
  late String? uId;
  late String? image;
  late String? dateTime;
  late String? text;
  late String? tags;
  late String? postImage;

  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    this.tags,
    this.dateTime,
    this.postImage,
    this.text,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json?['name'];
    uId = json?['uId'];
    dateTime = json?['dateTime'];
    text = json?['text'];
    tags = json?['tags'];
    postImage = json?['postImage'];
    image = json?['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime' : dateTime,
      'postImage' : postImage,
      'text' : text,
      'tags' : tags,
    };
  }
}
