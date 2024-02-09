import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget commonCachedNetworkImage(String? url,
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url!,
            height: height,
            width: width,
            fit: fit,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

InputDecoration buildInputDecoration(String name) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 16, top: 16, right: 8),
    labelText: name,
    labelStyle: primaryTextStyle(
        color: appStore.isDarkMode ? colorWhite : textNameColor),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
  );
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  await launch(url, forceWebView: forceWebView, enableJavaScript: true)
      .catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

String storeBaseURL() {
  return isAndroid ? playStoreBaseURL : appStoreBaseUrl;
}

Future<LatLng> getCurrentLocation({LatLng? currentLatLng}) async {
  Position? position = await Geolocator.getLastKnownPosition();
  currentLatLng = LatLng(position!.latitude, position.longitude);
  return currentLatLng;
}

Future<String?> getUserCurrentCity() async {
  if (await checkPermission()) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return place.locality;
  } else {
    throw 'Location permission not allowed';
  }
}

Future<void> saveOneSignalPlayerId() async {
  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId.validate().isNotEmpty)
      await setValue(PLAYER_ID, value.userId.validate());
  });
}

String getCurrency(String amt) {
  String amount = "${appStore.currency} ${0}";
  return amount;
}

Future<void> sendPushNotifications(
    {String? title,
    String? content,
    List<String?>? listUser,
    String? orderId}) async {
  Map dataMap = {};

  if (orderId != null) {
    dataMap.putIfAbsent('orderId', () => orderId);
  }

  Map req = {
    'headings': {'en': title},
    'contents': {'en': content},
    'data': dataMap,
    'app_id': mOneSignalAppId,
    'android_channel_id': mOneSignalChannelId,
    "include_player_ids": listUser,
  };

  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode);
  log(res.body);

  if (res.statusCode.isSuccessful()) {
    return;
  } else {
    throw errorSomethingWentWrong;
  }
}

String getOrderStatusText(String orderStatus) {
  if (orderStatus == ORDER_RECEIVED) {
    return appStore.translate('order_is_being_approved');
  } else if (orderStatus == ORDER_ACCEPTED) {
    return "A delivery boy is assigned";
  } else if (orderStatus == ORDER_PICKUP) {
    return appStore.translate('your_food_is_on_the_way');
  } else if (orderStatus == ORDER_DELIVERED) {
    return appStore.translate('order_is_delivered');
  } else if (orderStatus == ORDER_CANCELLED) {
    return appStore.translate('cancelled');
  }
  return orderStatus;
}

Color getOrderStatusColor(String? orderStatus) {
  if (orderStatus == ORDER_RECEIVED) {
    return Color(0xFF9A8500);
  } else if (orderStatus == ORDER_PENDING) {
    return Color(0xFF6A8500);
  } else if (orderStatus == ORDER_ACCEPTED) {
    return Colors.orangeAccent;
  } else if (orderStatus == ORDER_PICKUP) {
    return Colors.greenAccent;
  } else if (orderStatus == ORDER_DELIVERED) {
    return Colors.green;
  } else if (orderStatus == ORDER_CANCELLED) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}

Future<bool> checkPermission() async {
  // Request app level location permission
  LocationPermission locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.whileInUse ||
      locationPermission == LocationPermission.always) {
    // Check system level location permission
    if (!await Geolocator.isLocationServiceEnabled()) {
      return await Geolocator.openLocationSettings()
          .then((value) => false)
          .catchError((e) => false);
    } else {
      return true;
    }
  } else {
    toast(appStore.translate('allow_location_permission'));

    // Open system level location permission
    await Geolocator.openAppSettings();

    return false;
  }
}

String getAmount(int data) {
  final numberFormat = NumberFormat.decimalPattern();
  // String data2 = "₹ " + data.toString() + " /-";
  var amount = numberFormat.format(data);
  String data2 = "\CFA " + amount.toString() + "";

  return data2;
}
