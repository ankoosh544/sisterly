class Address {
  final int id;
  final String name;
  final String address1;
  final String? address2;
  final String country;
  final String province;
  final String zip;
  final String note;
  final String city;
  final String? email;
  final String? phone;
  final bool active;

  Address(this.id, this.name, this.address1, this.address2, this.country, this.province, this.zip, this.note, this.city, this.active, this.email, this.phone);

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(json["id"], json["name"], json["address1"], json["address2"], json["country"], json["province"], json["zip"], json["note"], json["city"], json["active"], json["email"], json["phone"]);
  }
}