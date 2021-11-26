class Filters {

  String? model;
  List<int> conditions = [];
  List<int> colors = [];
  List<int> deliveryModes = [];
  double maxPrice = 100;
  DateTime availableFrom = DateTime.now();
  DateTime availableTo = DateTime.now().add(Duration(days: 30));
  bool onlySameCity = false;

}