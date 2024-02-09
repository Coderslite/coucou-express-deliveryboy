import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/AppLocalizations.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  Color primaryColor = Colors.blue;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  bool isDarkMode = false;

  @observable
  String userCurrentCity = '';

  @observable
  AppBarTheme appBarTheme = AppBarTheme();

  @observable
  String selectedLanguage = defaultLanguage;

  @observable
  AppLocalizations? appLocale;

  @observable
  bool receiptUploaded = false;

  @observable
  String currency = 'CFA';

  @observable
  double constantDeliveryCharge = 0.0;

  @observable
  double kmDeliveryCharge = 0.0;

  @action
  void setConstantDeliveryCharge(double value) {
    constantDeliveryCharge = value;
  }

  @action
  void setKmDeliveryCharge(double value) {
    kmDeliveryCharge = value;
  }

  @action
  void setAppLocalization(BuildContext context) {
    appLocale = AppLocalizations.of(context);
  }

  String translate(String key) {
    return appLocale!.translate(key);
  }

  @action
  void setLanguage(String val) {
    selectedLanguage = val;
  }

  @action
  void setPrimaryColor(Color color) => primaryColor = color;

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  Future<void> setUserCurrentCity(String val) async {
    userCurrentCity = val;
    await setValue(CITY, val);
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  @action
  Future<void> setDarkMode(bool aIsDarkMode) async {
    isDarkMode = aIsDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;

      appBarBackgroundColorGlobal = scaffoldSecondaryDark;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;

      appBarBackgroundColorGlobal = Colors.white;
    }

    appBarTheme = AppBarTheme(
      brightness: appStore.isDarkMode ? Brightness.dark : Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              appStore.isDarkMode ? Brightness.dark : Brightness.light),
    );
  }

  @action
  Future<void> setReceiptUpload(bool receiptUpload) async {
    receiptUploaded = receiptUpload;
  }

  @action
  Future<void> changeCurrency(String cur) async {
    currency = cur;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('currenct', cur);
  }
}
