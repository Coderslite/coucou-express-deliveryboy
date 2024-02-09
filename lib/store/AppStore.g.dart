// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$primaryColorAtom =
      Atom(name: '_AppStore.primaryColor', context: context);

  @override
  Color get primaryColor {
    _$primaryColorAtom.reportRead();
    return super.primaryColor;
  }

  @override
  set primaryColor(Color value) {
    _$primaryColorAtom.reportWrite(value, super.primaryColor, () {
      super.primaryColor = value;
    });
  }

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$userCurrentCityAtom =
      Atom(name: '_AppStore.userCurrentCity', context: context);

  @override
  String get userCurrentCity {
    _$userCurrentCityAtom.reportRead();
    return super.userCurrentCity;
  }

  @override
  set userCurrentCity(String value) {
    _$userCurrentCityAtom.reportWrite(value, super.userCurrentCity, () {
      super.userCurrentCity = value;
    });
  }

  late final _$appBarThemeAtom =
      Atom(name: '_AppStore.appBarTheme', context: context);

  @override
  AppBarTheme get appBarTheme {
    _$appBarThemeAtom.reportRead();
    return super.appBarTheme;
  }

  @override
  set appBarTheme(AppBarTheme value) {
    _$appBarThemeAtom.reportWrite(value, super.appBarTheme, () {
      super.appBarTheme = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$appLocaleAtom =
      Atom(name: '_AppStore.appLocale', context: context);

  @override
  AppLocalizations? get appLocale {
    _$appLocaleAtom.reportRead();
    return super.appLocale;
  }

  @override
  set appLocale(AppLocalizations? value) {
    _$appLocaleAtom.reportWrite(value, super.appLocale, () {
      super.appLocale = value;
    });
  }

  late final _$receiptUploadedAtom =
      Atom(name: '_AppStore.receiptUploaded', context: context);

  @override
  bool get receiptUploaded {
    _$receiptUploadedAtom.reportRead();
    return super.receiptUploaded;
  }

  @override
  set receiptUploaded(bool value) {
    _$receiptUploadedAtom.reportWrite(value, super.receiptUploaded, () {
      super.receiptUploaded = value;
    });
  }

  late final _$currencyAtom =
      Atom(name: '_AppStore.currency', context: context);

  @override
  String get currency {
    _$currencyAtom.reportRead();
    return super.currency;
  }

  @override
  set currency(String value) {
    _$currencyAtom.reportWrite(value, super.currency, () {
      super.currency = value;
    });
  }

  late final _$constantDeliveryChargeAtom =
      Atom(name: '_AppStore.constantDeliveryCharge', context: context);

  @override
  double get constantDeliveryCharge {
    _$constantDeliveryChargeAtom.reportRead();
    return super.constantDeliveryCharge;
  }

  @override
  set constantDeliveryCharge(double value) {
    _$constantDeliveryChargeAtom
        .reportWrite(value, super.constantDeliveryCharge, () {
      super.constantDeliveryCharge = value;
    });
  }

  late final _$kmDeliveryChargeAtom =
      Atom(name: '_AppStore.kmDeliveryCharge', context: context);

  @override
  double get kmDeliveryCharge {
    _$kmDeliveryChargeAtom.reportRead();
    return super.kmDeliveryCharge;
  }

  @override
  set kmDeliveryCharge(double value) {
    _$kmDeliveryChargeAtom.reportWrite(value, super.kmDeliveryCharge, () {
      super.kmDeliveryCharge = value;
    });
  }

  late final _$setUserCurrentCityAsyncAction =
      AsyncAction('_AppStore.setUserCurrentCity', context: context);

  @override
  Future<void> setUserCurrentCity(String val) {
    return _$setUserCurrentCityAsyncAction
        .run(() => super.setUserCurrentCity(val));
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  late final _$setReceiptUploadAsyncAction =
      AsyncAction('_AppStore.setReceiptUpload', context: context);

  @override
  Future<void> setReceiptUpload(bool receiptUpload) {
    return _$setReceiptUploadAsyncAction
        .run(() => super.setReceiptUpload(receiptUpload));
  }

  late final _$changeCurrencyAsyncAction =
      AsyncAction('_AppStore.changeCurrency', context: context);

  @override
  Future<void> changeCurrency(String cur) {
    return _$changeCurrencyAsyncAction.run(() => super.changeCurrency(cur));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setConstantDeliveryCharge(double value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setConstantDeliveryCharge');
    try {
      return super.setConstantDeliveryCharge(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setKmDeliveryCharge(double value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setKmDeliveryCharge');
    try {
      return super.setKmDeliveryCharge(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAppLocalization(BuildContext context) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setAppLocalization');
    try {
      return super.setAppLocalization(context);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLanguage');
    try {
      return super.setLanguage(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrimaryColor(Color color) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setPrimaryColor');
    try {
      return super.setPrimaryColor(color);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
primaryColor: ${primaryColor},
isLoggedIn: ${isLoggedIn},
isLoading: ${isLoading},
isDarkMode: ${isDarkMode},
userCurrentCity: ${userCurrentCity},
appBarTheme: ${appBarTheme},
selectedLanguage: ${selectedLanguage},
appLocale: ${appLocale},
receiptUploaded: ${receiptUploaded},
currency: ${currency},
constantDeliveryCharge: ${constantDeliveryCharge},
kmDeliveryCharge: ${kmDeliveryCharge}
    ''';
  }
}
