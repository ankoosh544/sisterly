class Filters {

  String? model;
  List<int> conditions = [];
  List<int> colors = [];
  List<int> deliveryModes = [];
  double maxPrice = 1000;
  DateTime availableFrom = DateTime.now();
  DateTime availableTo = DateTime.now().add(Duration(days: 30));
  bool onlySameCity = false;

  areSet() {
    return model != null
        || conditions.isNotEmpty
        || colors.isNotEmpty
        || deliveryModes.isNotEmpty
        || maxPrice != 1000
        || onlySameCity
    ;
  }

}