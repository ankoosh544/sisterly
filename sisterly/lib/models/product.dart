class Product {
  final int id;
  final String model;
  List<String> images = [];
  List<String> videos = [];
  final int brandId;
  final String brandName;
  final int colorId;
  final String colorName;
  final String colorHex;
  final int materialId;
  final String materialName;
  final double priceRetail;
  final double priceOffer;
  final double sellingPrice;
  final String? conditions;
  final String? size;
  final String? year;

  Product(this.id, this.model, this.brandId, this.brandName, this.colorId, this.colorName, this.colorHex, this.materialId, this.materialName, this.priceRetail, this.priceOffer, this.sellingPrice, this.conditions, this.size, this.year);

  static getArrayDesc(item) {
    if(item.isNotEmpty && item.length > 1) {
      return item[1];
    }

    return "";
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    Product prod = Product(json["id"], json["model"], json["brand"]["id"], json["brand"]["name"], json["color"]["id"], json["color"]["color"], json["color"]["hexadecimal"], json["material"]["id"], json["material"]["material"], json["price_retail"], json["price_offer"], json["selling_price"], getArrayDesc(json["conditions"]), getArrayDesc(json["size"]), getArrayDesc(json["year"]));

    var media = json["media"];

    for (var img in media["images"]) {
      prod.images.add(img["image"]);
    }

    return prod;
  }
}