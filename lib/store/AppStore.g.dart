// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$primaryColorAtom = Atom(name: '_AppStore.primaryColor');

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

  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

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

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

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

  final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode');

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

  final _$userCurrentCityAtom = Atom(name: '_AppStore.userCurrentCity');

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

  final _$appBarThemeAtom = Atom(name: '_AppStore.appBarTheme');

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

  final _$selectedLanguageAtom = Atom(name: '_AppStore.selectedLanguage');

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

  final _$appLocaleAtom = Atom(name: '_AppStore.appLocale');

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

  final _$setUserCurrentCityAsyncAction =
      AsyncAction('_AppStore.setUserCurrentCity');

  @override
  Future<void> setUserCurrentCity(String val) {
    return _$setUserCurrentCityAsyncAction
        .run(() => super.setUserCurrentCity(val));
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode');

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

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
appLocale: ${appLocale}
    ''';
  }
}
