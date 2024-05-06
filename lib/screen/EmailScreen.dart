import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/screen/CompleteProfileScreen.dart';
import 'package:food_delivery/screen/DashboardScreen.dart';
import 'package:food_delivery/screen/ForgotPasswordScreen.dart';
import 'package:food_delivery/screen/LoginScreen.dart';
import 'package:food_delivery/screen/SignUpScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class EmailScreen extends StatefulWidget {
  static String tag = '/EmailScreen';

  @override
  EmailScreenState createState() => EmailScreenState();
}

class EmailScreenState extends State<EmailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool isLoading = false;

  handleCheckUser() async {
    try {
      isLoading = true;
      setState(() {});
      var isAvailable = await userService.isEmailExist(emailController.text);
      if (isAvailable) {
        snackBar(
          backgroundColor: fireBrick,
          context,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Authentication Failed",
                style: secondaryTextStyle(size: 12, color: white),
              ),
              Text(
                "This email already exist in the database",
                style: boldTextStyle(size: 16, color: white),
              )
            ],
          ),
        );
      } else {
        SignUpScreen(
          email: emailController.text,
        ).launch(context);
      }
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // if (getStringAsync(PLAYER_ID).isNotEmpty) saveOneSignalPlayerId();

    Geolocator.requestPermission();
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
                        Text("Create Account", style: boldTextStyle(size: 25)),
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
                        AppButton(
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius(50)),
                          color: primaryColor,
                          width: context.width(),
                          onTap: () {
                            handleCheckUser();
                          },
                          text: "Continue",
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
                            Text(appStore.translate('sign_in'),
                                    style: boldTextStyle(color: errorColor))
                                .onTap(() {
                              LoginScreen().launch(context);
                            })
                          ],
                        )
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 32)
                  ],
                ),
              ),
            ),
            Loader().center().visible(isLoading)
          ],
        ),
      ),
    );
  }
}
