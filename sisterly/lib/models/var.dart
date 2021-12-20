import 'package:sisterly/models/delivery_mode.dart';

import 'generic.dart';

List<DeliveryMode> deliveryTypes = [
  DeliveryMode(1, 'Di persona'),
  DeliveryMode(3, 'Corriere'),
  DeliveryMode(13, 'Di persona o corriere'),
];

List<Generic> productConditions = [
  Generic(1, 'Eccellenti'),
  Generic(2, 'Buone'),
  Generic(3, 'Scarse')
];

List<Generic> bagYears = [
  Generic(1, '1-2'),
  Generic(2, '2+')
];

List<Generic> bagSizes = [
  Generic(1, 'Piccola'),
  Generic(2, 'Media'),
  Generic(3, 'Grande')
];

/*
Orders status
1 - WAITING FOR ACCEPTANCE
2 - WAITING FOR PAYMENT
3 - PAYMENT IN PROGRESS
4 - PAID
5 - BORROWED
6 - CLOSED
7 - REJECTED
 */

getGenericName(id, array) {
  var cond = array.where((element) => element.id == id);

  if(cond.isNotEmpty) {
    return cond.first.name;
  } else {
    return id.toString();
  }
}

getDeliveryTypeName(id) {
  var cond = deliveryTypes.where((element) => element.id == id);

  if(cond.isNotEmpty) {
    return cond.first.description;
  } else {
    return id.toString();
  }
}