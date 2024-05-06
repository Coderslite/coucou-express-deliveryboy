import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/screen/CompleteProfileScreen.dart';
import 'package:food_delivery/screen/DashboardScreen.dart';
import 'package:food_delivery/screen/EmailScreen.dart';
import 'package:food_delivery/screen/ForgotPasswordScreen.dart';
import 'package:food_delivery/screen/SignUpScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // if (getStringAsync(PLAYER_ID).isNotEmpty) saveOneSignalPlayerId();

    Geolocator.requestPermission();
  }

  void updateToken(String userId) async {
    var prefs = await SharedPreferences.getInstance();
    var token = await _firebaseMessaging.getToken();
    prefs.setString(PLAYER_ID, token.toString());

    userService.updateDocument(getStringAsync(USER_ID), {
      "oneSignalPlayerId": token,
    });
  }

  Future<void> signIn() async {
    if (await checkPermission()) {
      if (formKey.currentState!.validate()) {
        appStore.setLoading(true);

        await authService
            .signInWithEmailPassword(
                email: emailController.text.trim(),
                password: passController.text.trim())
            .then((value) async {
          appStore.setLoading(false);

          if (getIntAsync(USER_CHECK) == 0 &&
              getStringAsync(USER_ROLE) == DELIVERY_BOY) {
            toast(
                'You profile is under review. Wait some time or contact your administrator.');
            appStore.setLoggedIn(false);
          } else {
            appStore.setLoggedIn(true);

            DashboardScreen().launch(context, isNewTask: true);
          }
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    32.height,
                    commonCachedNetworkImage(
                      'images/Login_icon.png',
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('sign_in'),
                            style: boldTextStyle(size: 25)),
                        16.height,
                        AppTextField(
                          focus: emailFocus,
                          nextFocus: passwordFocus,
                          controller: emailController,
                          textFieldType: TextFieldType.EMAIL,
                          errorThisFieldRequired:
                              appStore.translate('this_field_is_required'),
                          decoration:
                              buildInputDecoration(appStore.translate('email')),
                        ),
                        16.height,
                        AppTextField(
                          controller: passController,
                          focus: passwordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          errorThisFieldRequired:
                              appStore.translate('this_field_is_required'),
                          errorMinimumPasswordLength:
                              appStore.translate('minimum_password_length'),
                          decoration: buildInputDecoration(
                              appStore.translate('password')),
                          onFieldSubmitted: (val) {
                            signIn();
                          },
                        ),
                        16.height,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(appStore.translate('forgot_password'),
                                  style: primaryTextStyle(color: errorColor),
                                  textAlign: TextAlign.start)
                              .onTap(() {
                            ForgotPasswordScreen().launch(context);
                          }),
                        ),
                        16.height,
                        AppButton(
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius(50)),
                          color: primaryColor,
                          width: context.width(),
                          onTap: () {
                            signIn();
                          },
                          text: appStore.translate('sign_in'),
                          textStyle: boldTextStyle(color: white),
                        ),
                        16.height,
                        AppButton(
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius(50)),
                          onTap: () async {
                            if (await checkPermission()) {
                              if (getStringAsync(PLAYER_ID).isEmpty) {
                                // await saveOneSignalPlayerId();
                                if (getStringAsync(PLAYER_ID).isEmpty)
                                  return toast(errorMessage);
                              }
                              appStore.setLoading(true);

                              authService.signInWithGoogle().then((value) {
                                appStore.setLoading(false);

                                if (getIntAsync(USER_CHECK) == 0 &&
                                    getStringAsync(USER_ROLE) == DELIVERY_BOY) {
                                  toast(appStore.translate(
                                      'you_are_not_approved_by_admin_yet_contact_your_administrator'));
                                } else {
                                  if (value.number.validate().isNotEmpty) {
                                    DashboardScreen()
                                        .launch(context, isNewTask: true);
                                  } else {
                                    CompleteProfileScreen(value)
                                        .launch(context);
                                  }
                                }
                              }).catchError((error) {
                                appStore.setLoading(false);

                                toast(error.toString());
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoogleLogoWidget(),
                              20.width,
                              Text(appStore.translate('continue_with_google'),
                                  style: primaryTextStyle(size: 16)),
                            ],
                          ),
                        ),
                        30.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(appStore.translate('have_an_account'),
                                style: primaryTextStyle()),
                            8.width,
                            Text(appStore.translate('sign_up'),
                                    style: boldTextStyle(color: errorColor))
                                .onTap(() {
                              EmailScreen().launch(context);
                            })
                          ],
                        )
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 32)
                  ],
                ),
              ),
            ),
            Observer(
                builder: (_) => Loader().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
