class Product {
  final int id;
  final String model;
  List<String> images = [];
  List<String> videos = [];
  final String brandId;
  final String brandName;
  final String colorId;
  final String colorName;
  final String colorHex;
  final String materialId;
  final String materialName;
  final double priceRetail;
  final double priceOffer;
  final double sellingPrice;

  Product(this.id, this.model, this.brandId, this.brandName, this.colorId, this.colorName, this.colorHex, this.materialId, this.materialName, this.priceRetail, this.priceOffer, this.sellingPrice);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json["id"], json["model"], json["brand"]["id"], json["brand"]["name"], json["color"]["id"], json["color"]["name"], json["color"]["hexadecimal"], json["material"]["id"], json["material"]["material"], json["priceRetail"], json["priceOffer"], json["sellingPrice"]);
  }
}