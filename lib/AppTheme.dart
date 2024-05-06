import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: createMaterialColor(colorPrimary),
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: colorPrimary,
        unselectedItemColor: black),
    iconTheme: IconThemeData(color: scaffoldSecondaryDark),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: viewLineColor,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      // brightness: Brightness.light,
      systemOverlayStyle:
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: scaffoldColorDark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appButtonColorDark,
        unselectedItemColor: white,
        selectedItemColor: primaryColor),
    iconTheme: IconThemeData(color: Colors.white),
    dialogBackgroundColor: scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    dividerColor: Colors.white12,
    cardColor: scaffoldSecondaryDark,
    appBarTheme: AppBarTheme(
      color: scaffoldColorDark,
      // brightness: Brightness.dark,
      systemOverlayStyle:
          SystemUiOverlayStyle(systemNavigationBarColor: scaffoldColorDark),
    ),
    dialogTheme: DialogTheme(shape: dialogShape()),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: scaffoldSecondaryDark),
  ).copyWith(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
