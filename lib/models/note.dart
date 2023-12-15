class Note {
  String? id;
  String? userid;
  String? title;
  String? content;
  DateTime? dateadded;

  Note({
    this.id,
    this.userid,
    this.title,
    this.content,
    this.dateadded,
  });

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map["_id"],
    userid: map["userid"],
    title: map["title"],
    content: map["content"],
    dateadded: DateTime.tryParse(map["dateadded"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userid": userid,
    "title": title,
    "content": content,
    "dateadded": dateadded!.toIso8601String(),
  };
}