import 'dart:convert';

class Note {
  final String? id;
  final String userid;
  String title;
  String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Note({
    this.id,
    required this.userid,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "userid": userid,
        "title": title,
        "content": content,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['_id'] ?? '',
        userid: map["userid"] ?? '',
        title: map["title"] ?? '',
        content: map["content"] ?? '',
        createdAt: map["createdAt"] != null
            ? DateTime.parse(map["createdAt"])
            : DateTime.now(),
        updatedAt: map["updatedAt"] != null
            ? DateTime.parse(map["updatedAt"])
            : DateTime.now(),
      );

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
