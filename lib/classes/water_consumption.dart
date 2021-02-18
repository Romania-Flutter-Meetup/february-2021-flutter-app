class WaterConsumption {
  int id;
  String apartment;
  String bathroomHot;
  String bathroomCold;
  String kitchenHot;
  String kitchenCold;
  String createdAt;

  WaterConsumption(
      {this.id,
      this.apartment,
      this.bathroomHot,
      this.bathroomCold,
      this.kitchenHot,
      this.kitchenCold,
      this.createdAt});

  WaterConsumption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apartment = json['apartment'];
    bathroomHot = json['bathroomHot'].toString();
    bathroomCold = json['bathroomCold'].toString();
    kitchenHot = json['kitchenHot'].toString();
    kitchenCold = json['kitchenCold'].toString();
    createdAt = json['createdAt'];
  }
}
