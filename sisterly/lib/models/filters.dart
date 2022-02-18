class Filters {

  String? model;
  List<int> conditions = [];
  List<int> colors = [];
  List<int> deliveryModes = [];
  double maxPrice = 1000;
  DateTime? availableFrom;
  DateTime? availableTo;
  bool onlySameCity = false;
  int? brand;

  areSet() {
    return model != null
        || conditions.isNotEmpty
        || colors.isNotEmpty
        || deliveryModes.isNotEmpty
        || maxPrice != 1000
        || onlySameCity
        || brand != null
    ;
  }

}