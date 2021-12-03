import 'package:sisterly/models/account.dart';
import 'package:sisterly/models/product.dart';
import 'package:sisterly/models/state.dart';

import 'delivery_mode_offer.dart';

class Offer {

  final int id;
  final Account user;
  final Product product;
  final State state;
  final String price;
  final DateTime dateStart;
  final DateTime dateEnd;
  final DeliveryModeOffer deliveryMode;

  Offer(this.id, this.user, this.product, this.state, this.price, this.dateStart, this.dateEnd, this.deliveryMode);

  static getArrayDesc(item) {
    if(item.isNotEmpty && item.length > 1) {
      return item[1];
    }

    return "";
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    Offer prod = Offer(
      json["id"],
      Account.fromJson(json["user_id"]),
      Product.fromJson(json["product"]),
      State.fromJson(json["state"]),
      json["price"],
      DateTime.parse(json["date_start"]),
      DateTime.parse(json["date_end"]),
      DeliveryModeOffer.fromJson(json["delivery_mode"])
    );

    return prod;
  }
}