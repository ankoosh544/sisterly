class Document {
  final String id;
  final String status;
  final String type;

  Document(this.id, this.status, this.type);

  factory Document.fromJson(Map<String, dynamic> json) {
    Document document = Document(json["id"], json["status"], json["type"]);
    return document;
  }
}