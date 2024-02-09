class CommonKey {
  static String id = 'id';
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';
}

class OrderKey {
  static String number = 'number';
  static String orderItems = 'listOfOrder';
  static String totalAmount = 'totalAmount';
  static String restaurantId = 'restaurantId';
  static String deliveryBoyId = 'deliveryBoyId';
  static String userId = 'userId';
  static String orderStatus = 'orderStatus';
  static String userAddress = 'userAddress';
  static String userLocation = 'userLocation';
  static String deliveryBoyLocation = 'deliveryBoyLocation';
  static String paymentMethod = 'paymentMethod';
  static String paymentStatus = 'paymentStatus';
  static String restaurantCity = 'restaurantCity';
  static String orderId = 'orderId';
  static String orderType = 'orderType';
  static String orderUrl = 'orderUrl';
  static String receiptUrl = 'receiptUrl';
  static String deliveryCharge = 'deliveryCharge';
  static String restaurantName = 'restaurantName';
  static String taken = 'taken';
  static String timeRemaining = 'acceptOrderTimeRemaining';
  static String pavilionNo = 'pavilionNo';
  static String deliveryLocation = 'deliveryLocation';
  static String deliveryAddress = 'deliveryAddress';
  static String deliveryAddressDescription = 'deliveryAddressDescription';
  static String otherInformation = 'otherInformation';
}

class RestaurantsKey {
  static String restaurantAddress = 'restaurantAddress';
  static String photoUrl = 'photoUrl';
  static String restaurantName = 'restaurantName';
  static String restaurantLocation = 'restaurantLocation';
  static String restaurantAddresss = 'restaurantAddress';
  static String restaurantContact = 'restaurantPhoneNumber';
}

class ReviewKey {
  static String deliveryBoyId = 'deliveryBoyId';
  static String orderId = 'orderId';
  static String rating = 'rating';
  static String review = 'review';
  static String userId = 'userId';
  static String userImage = 'userImage';
  static String userName = 'userName';
}

class UserKey {
  static String photoUrl = 'photoUrl';
  static String name = 'name';
  static String type = 'type';
  static String uid = 'uid';
  static String email = 'email';
  static String role = 'role';
  static String address = 'address';
  static String number = 'phoneNumber';
  static String loginType = 'loginType';
  static String city = 'city';
  static String isDeleted = 'isDeleted';
  static String oneSignalPlayerId = 'oneSignalPlayerId';
  static String isTester = 'isTester';
  static String availabilityStatus = 'availabilityStatus';
  static String latitude = 'latitude';
  static String longitude = 'longitude';
}

class OrderItemsKey {
  static String itemName = 'itemName';
  static String image = 'image';
  static String itemPrice = 'itemPrice';
  static String qty = 'qty';
  static String isSuggestedPrice = 'isSuggestedPrice';
}
