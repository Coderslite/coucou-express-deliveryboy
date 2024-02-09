import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/utils/ModelKey.dart';

class OrderModel {
  String? id;
  DateTime? createdAt;
  int? number;
  List<OrderItems>? orderItems;
  int? totalAmount;
  String? restaurantId;
  String? deliveryBoyId;
  String? userId;
  String? orderStatus;
  String? userAddress;
  GeoPoint? userLocation;
  GeoPoint? deliveryBoyLocation;
  String? deliveryLocation;
  String? deliveryAddresss;
  String? deliveryAddressDescription;
  String? pavilionNo;
  String? otherInformation;
  String? paymentMethod;
  String? paymentStatus;
  String? restaurantCity;
  String? orderId;
  String? orderType;
  String? orderUrl;
  List? receiptUrl;
  int? deliveryCharge;
  String? restaurantName;
  Timestamp? timeRemaining;

  OrderModel({
    this.id,
    this.createdAt,
    this.number,
    this.orderItems,
    this.totalAmount,
    this.restaurantId,
    this.userId,
    this.orderStatus,
    this.userLocation,
    this.deliveryBoyLocation,
    this.deliveryLocation,
    this.deliveryAddresss,
    this.deliveryAddressDescription,
    this.pavilionNo,
    this.userAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.restaurantCity,
    this.deliveryBoyId,
    this.orderId,
    this.orderType,
    this.orderUrl,
    this.receiptUrl,
    this.deliveryCharge,
    this.restaurantName,
    this.timeRemaining,
    this.otherInformation,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json[CommonKey.id],
      createdAt: json[CommonKey.createdAt] != null
          ? (json[CommonKey.createdAt] as Timestamp).toDate()
          : null,
      number: json[OrderKey.number],
      orderItems: json[OrderKey.orderItems] != null
          ? (json[OrderKey.orderItems] as List)
              .map((i) => OrderItems.fromJson(i))
              .toList()
          : null,
      totalAmount: json[OrderKey.totalAmount],
      restaurantId: json[OrderKey.restaurantId],
      userId: json[OrderKey.userId],
      orderStatus: json[OrderKey.orderStatus],
      userLocation: json[OrderKey.userLocation],
      deliveryBoyLocation: json[OrderKey.deliveryBoyLocation],
      userAddress: json[OrderKey.userAddress],
      paymentMethod: json[OrderKey.paymentMethod],
      paymentStatus: json[OrderKey.paymentStatus],
      restaurantCity: json[OrderKey.restaurantCity],
      deliveryBoyId: json[OrderKey.deliveryBoyId],
      orderId: json[OrderKey.orderId],
      orderType: json[OrderKey.orderType],
      orderUrl: json[OrderKey.orderUrl],
      receiptUrl: json[OrderKey.receiptUrl],
      deliveryCharge: json[OrderKey.deliveryCharge],
      restaurantName: json[OrderKey.restaurantName],
      timeRemaining: json[OrderKey.timeRemaining],
      pavilionNo: json[OrderKey.pavilionNo],
      deliveryLocation: json[OrderKey.deliveryLocation],
      deliveryAddressDescription: json[OrderKey.deliveryAddressDescription],
      deliveryAddresss: json[OrderKey.deliveryAddress],
      otherInformation: json[OrderKey.otherInformation],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[CommonKey.createdAt] = this.createdAt;
    data[OrderKey.number] = this.number;
    data[OrderKey.totalAmount] = this.totalAmount;
    data[OrderKey.restaurantId] = this.restaurantId;
    data[OrderKey.userId] = this.userId;
    data[OrderKey.orderStatus] = this.orderStatus;
    data[OrderKey.userLocation] = this.userLocation;
    data[OrderKey.deliveryBoyLocation] = this.deliveryBoyLocation;
    data[OrderKey.userAddress] = this.userAddress;
    data[OrderKey.paymentMethod] = this.paymentMethod;
    data[OrderKey.paymentStatus] = this.paymentStatus;
    data[OrderKey.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKey.restaurantCity] = this.restaurantCity;
    data[OrderKey.orderId] = this.orderId;
    data[OrderKey.orderStatus] = this.orderStatus;
    data[OrderKey.orderUrl] = this.orderUrl;
    data[OrderKey.receiptUrl] = this.receiptUrl;
    data[OrderKey.deliveryCharge] = this.deliveryCharge;
    data[OrderKey.restaurantName] = this.restaurantName;
    data[OrderKey.timeRemaining] = this.timeRemaining;
    data[OrderKey.pavilionNo] = this.pavilionNo;
    data[OrderKey.deliveryLocation] = this.deliveryLocation;
    data[OrderKey.deliveryAddressDescription] = this.deliveryAddressDescription;
    data[OrderKey.deliveryAddress] = this.deliveryAddresss;
    data[OrderKey.otherInformation] = this.otherInformation;
    if (this.orderItems != null) {
      data[OrderKey.orderItems] =
          this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  String? id;
  String? categoryId;
  String? categoryName;
  String? image;
  String? itemName;
  int? itemPrice;
  int? qty;
  bool? isSuggestedPrice;
  String? restaurantId;
  String? restaurantName;
  String? restaurantLocation;
  String? restaurantAddress;

  OrderItems({
    this.id,
    this.categoryId,
    this.categoryName,
    this.image,
    this.itemName,
    this.itemPrice,
    this.qty,
    this.isSuggestedPrice,
    this.restaurantId,
    this.restaurantName,
    this.restaurantLocation,
    this.restaurantAddress,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      restaurantLocation: json[RestaurantsKey.restaurantLocation],
      restaurantAddress: json[RestaurantsKey.restaurantAddress],
      restaurantName: json[RestaurantsKey.restaurantName],
      itemName: json[OrderItemsKey.itemName],
      image: json[OrderItemsKey.image],
      qty: json[OrderItemsKey.qty],
      itemPrice: json[OrderItemsKey.itemPrice],
      isSuggestedPrice: json[OrderItemsKey.isSuggestedPrice],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[OrderItemsKey.itemName] = this.itemName;
    data[OrderItemsKey.image] = this.image;
    data[OrderItemsKey.qty] = this.qty;
    data[OrderItemsKey.itemPrice] = this.itemPrice;
    data[OrderItemsKey.isSuggestedPrice] = this.isSuggestedPrice;
    return data;
  }
}
