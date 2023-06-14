import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/RestaurantsModel.dart';
import 'package:food_delivery/services/BaseService.dart';
import 'package:food_delivery/utils/ModelKey.dart';

class RestaurantsService extends BaseService {
  RestaurantsService() {
    ref = db.collection('restaurant');
  }

  Future<RestaurantsModel> getRestaurantById({String? restaurantId}) async {
    return await FirebaseFirestore.instance
        .collection("restaurant")
        .where(OrderKey.restaurantId, isEqualTo: restaurantId)
        .get()
        .then((res) {
      if (res.docs.isEmpty) {
        throw 'Restaurants not found';
      } else {
        return RestaurantsModel.fromJson(res.docs.first.data());
      }
    }).catchError((error) {
      throw error.toString();
    });
  }
}
