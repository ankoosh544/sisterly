import 'package:sisterly/models/delivery_mode.dart';
import 'package:sisterly/models/delivery_mode_offer.dart';
import 'package:sisterly/models/var.dart';

import 'account.dart';

class Product {
  final int id;
  final String model;
  List<String> images = [];
  List<String> videos = [];
  final Account owner;
  final int brandId;
  final String brandName;
  final int colorId;
  final String colorName;
  final String colorHex;
  final int materialId;
  final String? description;
  final String materialName;
  final double priceRetail;
  final double priceOffer;
  final double sellingPrice;
  final String? conditions;
  final int? conditionsId;
  final String? size;
  final int? sizeId;
  final String? year;
  final int? yearId;
  final DeliveryMode? deliveryType;
  bool usePriceAlgorithm;
  bool useDiscount;

  Product(
      this.id,
      this.model,
      this.owner,
      this.description,
      this.brandId,
      this.brandName,
      this.colorId,
      this.colorName,
      this.colorHex,
      this.materialId,
      this.materialName,
      this.priceRetail,
      this.priceOffer,
      this.sellingPrice,
      this.conditions,
      this.conditionsId,
      this.size,
      this.sizeId,
      this.year,
      this.yearId,
      this.deliveryType,
      this.usePriceAlgorithm,
      this.useDiscount);

  static getArrayDesc(item) {
    if (item.isNotEmpty && item.length > 1) {
      return item[1];
    }

    return "";
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    Product prod = Product(
        json["id"],
        json["model"],
        Account.fromJson(json["owner"]),
        json["description"],
        json["brand"]["id"],
        json["brand"]["name"],
        json["color"]["id"],
        json["color"]["color"],
        json["color"]["hexadecimal"],
        json["material"]["id"],
        json["material"]["material"],
        json["price_retail"],
        json["price_offer"],
        json["selling_price"],
        getGenericName(json["conditions"]["id"], productConditions),
        json["conditions"]["id"],
        getGenericName(json["size"]["id"], bagSizes),
        json["size"]["id"],
        getGenericName(json["year"]["id"], bagYears),
        json["year"]["id"],
        DeliveryMode.fromJson(json["delivery_type"]),
      json["use_price_algorithm"] ?? false,
      json["use_discount"] ?? false,
    );

    var media = json["media"];

    for (var img in media["images"]) {
      prod.images.add(img["image"]);
    }

    return prod;
  }
}
