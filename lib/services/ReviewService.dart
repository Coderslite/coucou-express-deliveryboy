import 'package:food_delivery/main.dart';
import 'package:food_delivery/model/ReviewModel.dart';
import 'package:food_delivery/services/BaseService.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewService extends BaseService {
  ReviewService() {
    ref = db.collection('deliveryBoyReviews');
  }

  Stream<List<ReviewModel>> restaurantOrderServices() {
    return ref.where(ReviewKey.deliveryBoyId, isEqualTo: getStringAsync(USER_ID)).snapshots().map((x) {
      return x.docs.map((y) => ReviewModel.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }
}
