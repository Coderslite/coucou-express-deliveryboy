import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/AppLocalizations.dart';
import 'package:food_delivery/AppTheme.dart';
import 'package:food_delivery/model/UserModel.dart';
import 'package:food_delivery/screen/SplashScreen.dart';
import 'package:food_delivery/services/AppSettingService.dart';
import 'package:food_delivery/services/AuthService.dart';
import 'package:food_delivery/services/OrderService.dart';
import 'package:food_delivery/services/RestaurantsService.dart';
import 'package:food_delivery/services/ReviewService.dart';
import 'package:food_delivery/services/UserService.dart';
import 'package:food_delivery/store/AppStore.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;

OrderService orderServices = OrderService();
RestaurantsService restaurantsServices = RestaurantsService();
UserService userService = UserService();
ReviewService reviewService = ReviewService();
AppSettingService appSettingService = AppSettingService();
AuthService authService = AuthService();
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Flutter Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request notification permissions
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  var prefs = await SharedPreferences.getInstance();
  var token = await _firebaseMessaging.getToken();
  prefs.setString(PLAYER_ID, token.toString());

// Handle incoming messages and display notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    // Display a local notification
    _displayLocalNotification(message);
  });

  await initialize(aLocaleLanguageList: [
    LanguageDataModel(
        id: 1,
        name: 'English',
        languageCode: 'en',
        flag: 'images/flag/ic_us.png'),
    LanguageDataModel(
        id: 2,
        name: 'Hindi',
        languageCode: 'hi',
        flag: 'images/flag/ic_india.png'),
    LanguageDataModel(
        id: 3,
        name: 'Arabic',
        languageCode: 'ar',
        flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(
        id: 4,
        name: 'Spanish',
        languageCode: 'es',
        flag: 'images/flag/ic_spain.png'),
    LanguageDataModel(
        id: 5,
        name: 'Afrikaans',
        languageCode: 'af',
        flag: 'images/flag/ic_south_africa.png'),
    LanguageDataModel(
        id: 6,
        name: 'French',
        languageCode: 'fr',
        flag: 'images/flag/ic_france.png'),
    LanguageDataModel(
        id: 7,
        name: 'German',
        languageCode: 'de',
        flag: 'images/flag/ic_germany.png'),
    LanguageDataModel(
        id: 8,
        name: 'Indonesian',
        languageCode: 'id',
        flag: 'images/flag/ic_indonesia.png'),
    LanguageDataModel(
        id: 9,
        name: 'Portuguese',
        languageCode: 'pt',
        flag: 'images/flag/ic_portugal.png'),
    LanguageDataModel(
        id: 10,
        name: 'Turkish',
        languageCode: 'tr',
        flag: 'images/flag/ic_turkey.png'),
    LanguageDataModel(
        id: 11,
        name: 'vietnam',
        languageCode: 'vi',
        flag: 'images/flag/ic_vitnam.png'),
    LanguageDataModel(
        id: 12,
        name: 'Dutch',
        languageCode: 'nl',
        flag: 'images/flag/ic_dutch.png'),
  ]);
  defaultLoaderAccentColorGlobal = primaryColor;
  defaultCurrencySymbol = currencySymbol;

  selectedLanguageDataModel =
      getSelectedLanguageModel(defaultLanguage: defaultLanguage);
  if (selectedLanguageDataModel != null) {
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  } else {
    selectedLanguageDataModel = localeLanguageList.first;
    appStore.setLanguage(selectedLanguageDataModel!.languageCode.validate());
  }

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }
  appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
  if (appStore.isLoggedIn) {
    appStore.setUserCurrentCity(getStringAsync(CITY));
  }

  String currency = getStringAsync('currency');

  if (currency.toString() == '') {
    appStore.currency = 'CFA';
  } else {
    appStore.currency = currency;
  }

  runApp(MyApp());
}

void _displayLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('com.coucouexpress.delivery', 'Coucou Express Delivery',
          importance: Importance.max, priority: Priority.high);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: message.data.toString());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        builder: scrollBehaviour(),
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}
