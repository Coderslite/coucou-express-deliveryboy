import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/screen/LoginScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  static String tag = '/SignUpScreen';

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  FocusNode userFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode numberFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
  }

  Future<void> signUp() async {
    if (await checkPermission()) {
      if (formKey.currentState!.validate()) {
        appStore.setLoading(true);

        getUserCurrentCity().then((city) async {
          if (city.validate().isNotEmpty) {
            appStore.setUserCurrentCity(city.validate());

            await authService
                .signUpWithEmailPassword(
              email: emailController.text.trim(),
              password: passWordController.text.trim(),
              displayName: usernameController.text.trim(),
              number: numberController.text.trim(),
            )
                .then((value) {
              appStore.setLoading(false);

              LoginScreen().launch(context, isNewTask: true);
            }).catchError((error) {
              appStore.setLoading(false);

              toast(error);
            });
          }
        }).catchError((e) {
          toast(e.toString());
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
                    22.height,
                    commonCachedNetworkImage(
                      'images/Sign_up_icon.png',
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.translate('sign_up'), style: boldTextStyle(size: 25)),
                        16.height,
                        AppTextField(
                          controller: usernameController,
                          focus: userFocus,
                          nextFocus: emailFocus,
                          textFieldType: TextFieldType.NAME,
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                          decoration: buildInputDecoration(appStore.translate('full_name')),
                        ),
                        16.height,
                        AppTextField(
                          controller: emailController,
                          focus: emailFocus,
                          nextFocus: numberFocus,
                          textFieldType: TextFieldType.EMAIL,
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                          decoration: buildInputDecoration(appStore.translate('email')),
                        ),
                        16.height,
                        AppTextField(
                          controller: numberController,
                          focus: numberFocus,
                          nextFocus: passwordFocus,
                          textFieldType: TextFieldType.PHONE,
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                          decoration: buildInputDecoration(appStore.translate('number')),
                        ),
                        16.height,
                        AppTextField(
                          controller: passWordController,
                          focus: passwordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          errorThisFieldRequired: appStore.translate('this_field_is_required'),
                          errorMinimumPasswordLength: appStore.translate('minimum_password_length'),
                          decoration: buildInputDecoration(appStore.translate('password')),
                          onFieldSubmitted: (val){
                            signUp();
                          },
                        ),
                        16.height,
                        AppButton(
                          shapeBorder: RoundedRectangleBorder(borderRadius: radius(50)),
                          color: primaryColor,
                          width: context.width(),
                          onTap: () {
                            signUp();
                          },
                          text: appStore.translate('sign_up'),
                          textStyle: boldTextStyle(color: white),
                        ),
                        32.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(appStore.translate('already_have_an_account'), style: primaryTextStyle()),
                            8.width,
                            Text(appStore.translate('sign_in'), style: boldTextStyle(color: errorColor)).onTap(() {
                              finish(context);
                            })
                          ],
                        )
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 16),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
