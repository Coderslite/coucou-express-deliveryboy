import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/services/BaseService.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderService extends BaseService {
  OrderService() {
    ref = db.collection('orders');
  }

  Stream<OrderModel> getOrderById(String? id) {
    return ref.where(CommonKey.id, isEqualTo: id).snapshots().map((event) =>
        OrderModel.fromJson(event.docs.first.data() as Map<String, dynamic>));
  }

  Future<OrderModel> getOrderByIdFuture(String? id) async {
    return await ref.where(CommonKey.id, isEqualTo: id).get().then((event) =>
        OrderModel.fromJson(event.docs.first.data() as Map<String, dynamic>));
  }

  // Stream<List<OrderModel>> restaurantOrderServices({String? restaurantId}) {
  //   return orderQuery(
  //           city: appStore.userCurrentCity,
  //           orderStatus: [ORDER_STATUS_COOKING],
  //           restaurantId: restaurantId)
  //       .snapshots()
  //       .map((x) {
  //     return x.docs
  //         .map((y) => OrderModel.fromJson(y.data() as Map<String, dynamic>))
  //         .toList();
  //   });
  // }

  Query orderQuery({
    String? restaurantId,
    List<String>? orderStatus,
    String? city,
    String deliveryBoyId = '',
    bool? taken,
  }) {
    if (deliveryBoyId.isEmpty) {
      print("delivery boy id is empty");
      return ref
          .where(OrderKey.restaurantCity, isEqualTo: city)
          .where(OrderKey.orderStatus, whereIn: orderStatus)
          .where(OrderKey.taken, isEqualTo: taken)
          .orderBy(CommonKey.createdAt, descending: true);
    } else {
      return ref
          .where(OrderKey.restaurantCity, isEqualTo: city)
          .where(OrderKey.orderStatus, whereIn: orderStatus)
          .where(OrderKey.deliveryBoyId, isEqualTo: deliveryBoyId)
          .where(OrderKey.taken, isEqualTo: taken)
          .orderBy(CommonKey.createdAt, descending: true);
    }
  }

  Stream<List<OrderModel>> deliveryOrderCharges() {
    return orderQuery1().snapshots().map((x) {
      return x.docs
          .map((y) => OrderModel.fromJson(y.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Query orderQuery1() {
    return ref
        .where(OrderKey.orderStatus, isEqualTo: ORDER_DELIVERED)
        .where(OrderKey.deliveryBoyId, isEqualTo: getStringAsync(USER_ID))
        .orderBy(CommonKey.createdAt, descending: true);
  }

  Query pendingOrderQuery() {
    return ref
        .where('orderStatus', isEqualTo: ORDER_PENDING)
        .where('deliveryBoyId', isEqualTo: null)
        .where('taken', isEqualTo: false)
        .orderBy('createdAt', descending: false);
    // order['orderStatus'] == ORDER_STATUS_RECEIVED &&
    //                       order['deliveryBoyId'] == getStringAsync(USER_ID) &&
    //                       order['taken'] == false
  }
}
