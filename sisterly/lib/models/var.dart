import 'package:sisterly/models/delivery_mode.dart';

import 'generic.dart';

List<DeliveryMode> deliveryTypes = [
  DeliveryMode(1, 'Face to face'),
  DeliveryMode(2, 'Rider'),
  DeliveryMode(3, 'Rider or face to face')
];

List<Generic> productConditions = [
  Generic(1, 'Excellent conditions'),
  Generic(2, 'Good conditions'),
  Generic(3, 'Poor conditions')
];

List<Generic> bagYears = [
  Generic(1, '1-2'),
  Generic(2, '2+')
];

List<Generic> bagSizes = [
  Generic(1, 'Small'),
  Generic(2, 'Medium'),
  Generic(3, 'Big')
];