// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:food_delivery/components/AppWidgets.dart';
// import 'package:food_delivery/main.dart';
// import 'package:food_delivery/model/OrderModel.dart';
// import 'package:food_delivery/model/UserModel.dart';
// import 'package:food_delivery/utils/Colors.dart';
// import 'package:food_delivery/utils/Common.dart';
// import 'package:food_delivery/utils/Constants.dart';
// import 'package:food_delivery/utils/ModelKey.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geocoding/geocoding.dart' as GC;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:url_launcher/url_launcher.dart';

// // ignore: must_be_immutable
// class TrackingScreen extends StatefulWidget {
//   OrderModel? orderModel;

//   String? orderId;

//   TrackingScreen({this.orderModel, this.orderId});

//   @override
//   TrackingScreenState createState() => TrackingScreenState();
// }

// class TrackingScreenState extends State<TrackingScreen> {
//   UserModel? userData;
//   String? addressRes;

//   // ignore: non_constant_identifier_names
//   double CAMERA_ZOOM = 13;

//   // ignore: non_constant_identifier_names
//   double CAMERA_TILT = 0;

//   // ignore: non_constant_identifier_names
//   double CAMERA_BEARING = 30;

//   // ignore: non_constant_identifier_names
//   LatLng SOURCE_LOCATION = LatLng(0.0, 0.0);

//   // ignore: non_constant_identifier_names
//   LatLng DEST_LOCATION = LatLng(0.0, 0.0);

//   // ignore: non_constant_identifier_names
//   LatLng RESTAURANTS_LOCATION = LatLng(0.0, 0.0);
//   late CameraPosition initialLocation;

//   String? userPlayerId = '';

//   bool isReached = false;
//   Completer<GoogleMapController> _controller = Completer();

//   Set<Marker> _markers = {};

//   Set<Polyline> _polyLines = {};

//   List<LatLng> polylineCoordinates = [];

//   late PolylinePoints polylinePoints;

//   late BitmapDescriptor sourceIcon;
//   late BitmapDescriptor destinationIcon;
//   late BitmapDescriptor restaurantsIcon;

//   bool isError = false;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   Future<void> init() async {
//     polylinePoints = PolylinePoints();
//     await loadBasicDetails();

//     if (isError) {
//       init();
//       return toast(errorMessage);
//     }

//     DEST_LOCATION = LatLng(widget.orderModel!.userLocation!.latitude,
//         widget.orderModel!.userLocation!.longitude);

//     orderServices.getOrderById(widget.orderModel!.id).listen((order) {
//       widget.orderModel = order;

//       setState(() {});
//     }).onError((error) {
//       toast(error.toString());
//     });

//     if (appStore.isDarkMode) {
//       setStatusBarColor(scaffoldColorDark);
//     } else {
//       setStatusBarColor(Colors.white);
//     }
//     setSourceAndDestinationIcons();

//     if (await checkPermission()) {
//       getAddress();
//     }

//     _polyLines.clear();
//     polylineCoordinates.clear();

//     setState(() {});
//   }

//   Future<void> loadBasicDetails() async {
//     isError = false;

//     if (widget.orderModel != null) {
//       widget.orderId = widget.orderModel!.id;
//     }
//     if (widget.orderId != null) {
//       await orderServices.getOrderByIdFuture(widget.orderId).then((value) {
//         widget.orderModel = value;

//         isReached = widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING ||
//             widget.orderModel!.orderStatus == ORDER_STATUS_COMPLETE;
//       }).catchError((e) {
//         isError = true;
//       });
//       await userService
//           .getUserById(userId: widget.orderModel!.userId)
//           .then((user) {
//         userData = user;

//         userPlayerId = userData!.oneSignalPlayerId;
//       }).catchError((e) {
//         isError = true;
//       });
//       await restaurantsServices
//           .getRestaurantById(restaurantId: widget.orderModel!.restaurantId)
//           .then((value) {
//         addressRes = value.restaurantAddress;
//       }).catchError((e) {
//         isError = true;
//       });
//     }
//   }

//   /// Get Current Location
//   // Future<void> startLocationTracking() async {
//   //   await BackgroundLocation.startLocationService();

//   //   BackgroundLocation.getLocationUpdates((location) {
//   //     SOURCE_LOCATION = LatLng(location.latitude!, location.longitude!);

//   //     GeoPoint data = GeoPoint(location.latitude!, location.longitude!);

//   //     orderServices.updateDocument(widget.orderModel!.id, {
//   //       OrderKey.deliveryBoyLocation: data,
//   //       CommonKey.updatedAt: DateTime.now(),
//   //     }).then((value) {
//   //       //
//   //     }).catchError((error) {
//   //       toast(error.toString());
//   //     });

//   //     _controller.future.then((value) {
//   //       value.animateCamera(CameraUpdate.newLatLng(SOURCE_LOCATION));
//   //     });
//   //     _polyLines.clear();
//   //     polylineCoordinates.clear();
//   //     setMapPins();
//   //     setPolyLines();
//   //   });
//   // }

//   Future<void> setSourceAndDestinationIcons() async {
//     sourceIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5), 'images/delivery_boy.png');
//     isReached
//         ? destinationIcon = await BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: 2.5),
//             'images/destination_map_marker.png')
//         : restaurantsIcon = await BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(devicePixelRatio: 2.5), 'images/restaurant.png');
//   }

//   Future<void> onMapCreated(GoogleMapController controller) async {
//     if (!_controller.isCompleted) {
//       _controller.complete(controller);
//       _controller = controller as Completer<GoogleMapController>;
//     }
//     await _controller.future.then((value) {
//       value.animateCamera(CameraUpdate.newLatLng(DEST_LOCATION));
//     });

//     _polyLines.clear();
//     polylineCoordinates.clear();
//     setMapPins();
//     setPolyLines();
//   }

//   void setMapPins() {
//     _markers.clear();

//     // source pin
//     _markers.add(Marker(
//         markerId: MarkerId('sourcePin'),
//         position: SOURCE_LOCATION,
//         icon: sourceIcon));
//     // destination pin
//     isReached
//         ? _markers.add(Marker(
//             markerId: MarkerId('destPin'),
//             position: DEST_LOCATION,
//             icon: destinationIcon))
//         : _markers.add(Marker(
//             markerId: MarkerId('restPin'),
//             position: RESTAURANTS_LOCATION,
//             icon: restaurantsIcon));
//   }

//   Future<void> setPolyLines() async {
//     PolylineResult result = (await polylinePoints.getRouteBetweenCoordinates(
//         googleMapAPIKey,
//         PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
//         widget.orderModel!.orderStatus == ORDER_STATUS_COOKING || isReached
//             ? PointLatLng(widget.orderModel!.userLocation!.latitude,
//                 widget.orderModel!.userLocation!.longitude)
//             : PointLatLng(RESTAURANTS_LOCATION.latitude,
//                 RESTAURANTS_LOCATION.longitude)));

//     if (result.points.validate().isNotEmpty) {
//       _polyLines.clear();
//       polylineCoordinates.clear();
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//       PolylineId id = PolylineId("poly");
//       _polyLines.clear();
//       _polyLines.remove(id);
//       _polyLines.add(
//         Polyline(
//           visible: true,
//           width: 5,
//           polylineId: id,
//           color: Color.fromARGB(255, 40, 122, 198),
//           points: polylineCoordinates,
//         ),
//       );
//     } else {
//       log(result.errorMessage);
//     }

//     setState(() {});
//   }

//   Future<void> getAddress() async {
//     final query = addressRes!;
//     List<GC.Location> locations = await locationFromAddress(query);
//     RESTAURANTS_LOCATION =
//         LatLng(locations.first.latitude, locations.first.longitude);
//   }

//   Future<void> completeDelivery() async {
//     /// Update document
//     orderServices.updateDocument(widget.orderModel!.id, {
//       OrderKey.orderStatus: ORDER_STATUS_COMPLETE,
//       OrderKey.paymentStatus: ORDER_PAYMENT_RECEIVED,
//       CommonKey.updatedAt: DateTime.now(),
//     }).then((value) {
//       userService.updateDocument(
//         getStringAsync(USER_ID),
//         {"availabilityStatus": true},
//       );
//       if (userPlayerId!.isNotEmpty) {
//         sendPushNotifications(
//             title: 'Order Update',
//             content: 'Your order is delivered',
//             listUser: [userPlayerId],
//             orderId: widget.orderId);
//       }
//       finish(context);
//     }).catchError((error) {
//       toast(error.toString());
//     });
//   }

//   @override
//   void dispose() {
//     setStatusBarColor(
//       appStore.isDarkMode ? scaffoldColorDark : white,
//       statusBarIconBrightness:
//           appStore.isDarkMode ? Brightness.light : Brightness.dark,
//       delayInMilliSeconds: 100,
//     );
//     super.dispose();
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     initialLocation = CameraPosition(
//       zoom: CAMERA_ZOOM,
//       bearing: CAMERA_BEARING,
//       tilt: CAMERA_TILT,
//       target: SOURCE_LOCATION,
//     );

//     return SafeArea(
//       child: Scaffold(
//         appBar: appBarWidget('#${widget.orderModel?.orderId?.validate()}'),
//         body: widget.orderModel != null
//             ? Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   GoogleMap(
//                     myLocationEnabled: false,
//                     compassEnabled: true,
//                     tiltGesturesEnabled: false,
//                     markers: _markers,
//                     zoomControlsEnabled: false,
//                     polylines: _polyLines,
//                     mapType: appStore.isDarkMode
//                         ? MapType.satellite
//                         : MapType.normal,
//                     initialCameraPosition: initialLocation,
//                     onMapCreated: onMapCreated,
//                   ),
//                   if (userData != null)
//                     Positioned(
//                       bottom: 0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20)),
//                             color: appStore.isDarkMode ? backColor : white),
//                         width: context.width(),
//                         padding: EdgeInsets.all(8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 commonCachedNetworkImage(
//                                         userData!.photoUrl.validate(),
//                                         fit: BoxFit.cover,
//                                         height: 50,
//                                         width: 50)
//                                     .cornerRadiusWithClipRRect(8)
//                                     .visible(userData!.photoUrl
//                                         .validate()
//                                         .isNotEmpty),
//                                 Icon(Icons.person, size: 40).visible(
//                                     userData!.photoUrl.validate().isEmpty),
//                                 8.width,
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(userData!.name.validate(),
//                                         style: boldTextStyle(),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis),
//                                     4.height,
//                                     Text(userData!.number.validate(),
//                                         style: primaryTextStyle(size: 14),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis),
//                                   ],
//                                 ).expand(),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: radius(),
//                                       color: white,
//                                       boxShadow: defaultBoxShadow()),
//                                   height: 35,
//                                   width: 35,
//                                   child:
//                                       Icon(Icons.call, color: blueButtonColor),
//                                 ).onTap(() {
//                                   launch("tel://${userData!.number}");
//                                 })
//                               ],
//                             ).paddingAll(8),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 createRichText(
//                                   list: [
//                                     TextSpan(
//                                         text: widget.orderModel!.userAddress
//                                             .validate(),
//                                         style: primaryTextStyle()),
//                                   ],
//                                   maxLines: 5,
//                                 ),
//                                 8.height,
//                                 orderStatusWidget(
//                                     widget.orderModel!.orderStatus),
//                               ],
//                             ).paddingAll(8),
//                             Row(
//                               children: [
//                                 AppButton(
//                                   text: appStore.translate('start'),
//                                   textStyle: primaryTextStyle(color: white),
//                                   color: Colors.red,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 4, horizontal: 8),
//                                   onTap: () async {
//                                     showConfirmDialog(
//                                             context,
//                                             appStore.translate(
//                                                 'did_you_picked_up_the_parcel'),
//                                             positiveText:
//                                                 appStore.translate('yes'),
//                                             negativeText:
//                                                 appStore.translate('no'))
//                                         .then((value) async {
//                                       if (value ?? false) {
//                                         DEST_LOCATION = LatLng(
//                                             widget.orderModel!.userLocation!
//                                                 .latitude,
//                                             widget.orderModel!.userLocation!
//                                                 .longitude);
//                                         isReached = true;
//                                         await setSourceAndDestinationIcons()
//                                             .then((value) async {
//                                           //
//                                         });

//                                         await orderServices.updateDocument(
//                                             widget.orderModel!.id, {
//                                           OrderKey.orderStatus:
//                                               ORDER_STATUS_DELIVERING,
//                                           CommonKey.updatedAt: DateTime.now(),
//                                         }).then((value) {
//                                           //
//                                         }).catchError((error) {
//                                           toast(error.toString());
//                                         });
//                                         setState(() {});
//                                       }
//                                     });
//                                   },
//                                 ).visible(widget.orderModel!.orderStatus ==
//                                     ORDER_STATUS_READY),
//                                 8.width,
//                                 if (widget.orderModel != null)
//                                   AppButton(
//                                     text: appStore.translate('complete'),
//                                     textStyle: primaryTextStyle(color: white),
//                                     color: Colors.green,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     onTap: () {
//                                       showConfirmDialog(
//                                               context,
//                                               appStore.translate(
//                                                   'did_you_reached_the_destination_and_got_payment'),
//                                               positiveText:
//                                                   appStore.translate('yes'),
//                                               negativeText:
//                                                   appStore.translate('no'))
//                                           .then((value) {
//                                         if (value ?? false) {
//                                           completeDelivery();
//                                         }
//                                       });
//                                     },
//                                   ).visible(
//                                     widget.orderModel!.orderStatus ==
//                                         ORDER_STATUS_DELIVERING,
//                                   ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   Observer(
//                       builder: (_) => Align(
//                           alignment: Alignment.center,
//                           child: Loader(color: Colors.red)
//                               .visible(appStore.isLoading))),
//                 ],
//               )
//             : Loader(),
//       ),
//     );
//   }
// }
