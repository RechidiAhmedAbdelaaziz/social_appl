// ignore_for_file: file_names

class MessageModel {
  late String? senderId;
  late String? reciverId;
  late String? dateTime;
  late String? text;
  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.dateTime,
    required this.text,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    senderId = json?['senderId'];
    reciverId = json?['reciverId'];
    text = json?['text'];
    dateTime = json?['datTime'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'dateTime': dateTime,
      'text': text,
    };
  }
}
