import 'package:sisterly/models/delivery_mode.dart';

import 'generic.dart';

List<DeliveryMode> deliveryTypes = [
  DeliveryMode(1, 'Di persona'),
  DeliveryMode(2, 'Fattorino'),
  DeliveryMode(12, 'Fattorino o di persona')
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