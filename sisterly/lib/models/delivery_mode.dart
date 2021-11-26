class DeliveryMode {
  final int id;
  final String description;

  DeliveryMode(this.id, this.description);

  factory DeliveryMode.fromJson(Map<String, dynamic> json) {
    DeliveryMode prod = DeliveryMode(json["id"], json["description"]);

    return prod;
  }
}