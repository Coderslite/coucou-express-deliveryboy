import 'package:food_delivery/utils/ModelKey.dart';

class RestaurantsModel {
  String? id;
  String? restaurantAddress;
  String? photoUrl;
  String? restaurantName;
  String? restaurantContact;

  RestaurantsModel(
      {this.restaurantAddress,
      this.photoUrl,
      this.restaurantName,
      this.restaurantContact,
      this.id});

  factory RestaurantsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantsModel(
      id: json[OrderKey.restaurantId],
      restaurantAddress: json[RestaurantsKey.restaurantAddress],
      photoUrl: json[RestaurantsKey.photoUrl],
      restaurantName: json[RestaurantsKey.restaurantName],
      restaurantContact: json[RestaurantsKey.restaurantContact],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[RestaurantsKey.restaurantAddress] = this.restaurantAddress;
    data[RestaurantsKey.photoUrl] = this.photoUrl;
    data[RestaurantsKey.restaurantName] = this.restaurantName;
    data[RestaurantsKey.restaurantContact] = this.restaurantContact;

    return data;
  }
}
