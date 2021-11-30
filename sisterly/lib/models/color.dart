class MyColor {
  final int id;
  final String name;
  final String hex;

  MyColor(this.id, this.name, this.hex);

  factory MyColor.fromJson(Map<String, dynamic> json) {
    MyColor color = MyColor(json["id"], json["name"], json["hexadecimal"]);

    return color;
  }
}