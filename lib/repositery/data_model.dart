class DataModelEntity {
  int? userId;
  int? id;
  String? title;
  String? body;

  DataModelEntity({this.userId, this.id, this.title, this.body});

  DataModelEntity.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }
}
