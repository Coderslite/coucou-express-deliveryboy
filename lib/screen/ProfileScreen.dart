import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery/components/ChangeAvailableStatusBottomSheet.dart';
import 'package:food_delivery/components/ThemeSelectionDialog.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/screen/AboutAppScreen.dart';
import 'package:food_delivery/screen/DeliveryIncomeScreen.dart';
import 'package:food_delivery/screen/EditProfileScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
  }

  @override
  void dispose() {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setAppLocalization(context);

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(appStore.translate('profile'), showBack: false),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(getStringAsync(USER_ID))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data!.data();
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          16.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonCachedNetworkImage(
                                getStringAsync(USER_PHOTO_URL),
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              ).cornerRadiusWithClipRRect(45).visible(
                                  getStringAsync(USER_PHOTO_URL).isNotEmpty),
                              Icon(Icons.person, size: 60).visible(
                                  getStringAsync(USER_PHOTO_URL).isEmpty),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              getStringAsync(USER_DISPLAY_NAME),
                                              style: boldTextStyle(size: 14)),
                                          Text(getStringAsync(USER_EMAIL),
                                              style:
                                                  secondaryTextStyle(size: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  2.height,
                                  InkWell(
                                    borderRadius: radius(),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        context: context,
                                        builder: (builder) {
                                          return ChangeAvailableStatusBottomSheet();
                                        },
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      margin:
                                          EdgeInsets.only(top: 4, bottom: 4),
                                      decoration: boxDecorationDefault(
                                        borderRadius: radius(),
                                        color: data!['availabilityStatus']
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          4.width,
                                          Icon(
                                              data['availabilityStatus']
                                                  ? Icons.check
                                                  : Icons.close,
                                              size: 14,
                                              color: data['availabilityStatus']
                                                  ? primaryColor
                                                  : colorPrimary),
                                          8.width,
                                          Text(
                                            data['availabilityStatus']
                                                ? appStore
                                                    .translate('available')
                                                : appStore
                                                    .translate('not_available'),
                                            style: boldTextStyle(
                                                color:
                                                    data['availabilityStatus']
                                                        ? primaryColor
                                                        : colorPrimary,
                                                size: 14),
                                          ),
                                          4.width,
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ).expand(),
                              IconButton(
                                onPressed: () {
                                  EditProfileScreen().launch(context);
                                },
                                icon: Icon(Icons.edit, color: blueButtonColor),
                              ),
                            ],
                          ).paddingOnly(left: 16, right: 16),
                          Divider(thickness: 1, height: 20),
                          Observer(
                            builder: (_) => SettingItemWidget(
                              leading: Icon(Icons.location_on_outlined),
                              title: appStore.translate('change_city'),
                              titleTextStyle: primaryTextStyle(),
                              subTitle: appStore.userCurrentCity,
                              onTap: () {
                                showConfirmDialog(
                                        context,
                                        appStore.translate(
                                            'do_you_want_to_change_the_city'),
                                        positiveText: appStore.translate('yes'),
                                        negativeText: appStore.translate('no'))
                                    .then((value) async {
                                  if (value ?? false) {
                                    appStore.setLoading(true);

                                    await getUserCurrentCity()
                                        .then((city) async {
                                      if (city.validate().isNotEmpty) {
                                        await userService.updateDocument(
                                            getStringAsync(USER_ID), {
                                          UserKey.city: city,
                                        }).then((value) async {
                                          toast(
                                              'Your current city is now $city');
                                        }).catchError((error) {
                                          toast(error.toString());
                                        });
                                      }
                                    }).catchError((e) {
                                      toast(e.toString());
                                    });

                                    appStore.setLoading(false);
                                  }
                                });
                              },
                            ),
                          ),
                          SettingItemWidget(
                            leading:
                                Icon(Icons.account_balance_wallet_outlined),
                            title: appStore.translate('my_Income'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              DeliveryIncomeScreen().launch(context);
                            },
                          ),
                          SettingItemWidget(
                            leading:
                                Icon(MaterialCommunityIcons.theme_light_dark),
                            title: appStore.translate('select_theme'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () async {
                              await showInDialog(
                                context,
                                child: ThemeSelectionDialog(),
                                contentPadding: EdgeInsets.zero,
                                title: Text(appStore.translate('select_theme'),
                                    style: primaryTextStyle(size: 20)),
                              );
                              setStatusBarColor(
                                appStore.isDarkMode ? scaffoldColorDark : white,
                                statusBarIconBrightness: appStore.isDarkMode
                                    ? Brightness.light
                                    : Brightness.dark,
                                delayInMilliSeconds: 100,
                              );
                              setState(() {});
                            },
                          ),
                          SettingItemWidget(
                            title: appStore.translate('language'),
                            leading: selectedLanguageDataModel != null
                                ? Image.asset(
                                    selectedLanguageDataModel!.flag.validate(),
                                    height: 24,
                                    width: 24)
                                : null,
                            subTitle: appStore.translate('choose_app_language'),
                            titleTextStyle: primaryTextStyle(),
                            trailing: Text(
                                getSelectedLanguageModel()!.name.validate(),
                                style: primaryTextStyle()),
                            onTap: () async {
                              await StatefulBuilder(
                                  builder: (context, setState) {
                                return Scaffold(
                                  appBar: appBarWidget(appStore
                                      .translate('choose_app_language')),
                                  body: LanguageListWidget(
                                    onLanguageChange: (val) async {
                                      appStore.setLanguage(
                                          val.languageCode.validate());

                                      finish(context);
                                    },
                                  ),
                                );
                              }).launch(context);

                              setState(() {});
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.assignment_outlined),
                            title: appStore.translate('privacy_policy'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              launchUrl(Privacy_Policy, forceWebView: true);
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.support_rounded),
                            title: appStore.translate('help_support'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              launchUrl(supportURL, forceWebView: true);
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.assignment_outlined),
                            title: appStore.translate('term_condition'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              launchUrl(Privacy_Policy, forceWebView: true);
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.share_outlined),
                            title: appStore.translate('share_app'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              PackageInfo.fromPlatform().then((value) {
                                String package = '';
                                if (isAndroid) package = value.packageName;

                                Share.share(
                                    'Share $mAppName app\n\n${storeBaseURL()}$package');
                              });
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.info_outline),
                            title: appStore.translate('about'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () {
                              AboutAppScreen().launch(context);
                            },
                          ),
                          SettingItemWidget(
                            leading: Icon(Icons.exit_to_app_rounded),
                            title: appStore.translate('logout'),
                            titleTextStyle: primaryTextStyle(),
                            onTap: () async {
                              bool? res = await showConfirmDialog(
                                  context,
                                  appStore.translate(
                                      'do_you_want_to_logout_from_the_app'),
                                  positiveText: appStore.translate('yes'),
                                  negativeText: appStore.translate('no'));
                              if (res ?? false) {
                                authService.logout(context);
                              }
                            },
                          ),
                          20.height,
                        ],
                      ),
                    ),
                    Observer(
                        builder: (_) => Loader().visible(appStore.isLoading)),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
