import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotEmailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(appStore.translate('forgot_password')),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.height,
              AppTextField(
                controller: forgotEmailController,
                textFieldType: TextFieldType.EMAIL,
                errorThisFieldRequired: appStore.translate('this_field_is_required'),
                decoration: buildInputDecoration(appStore.translate('email')),
              ),
              16.height,
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(50)),
                color: primaryColor,
                width: context.width(),
                onTap: () {
                  if(formKey.currentState!.validate()){
                    authService.forgotPassword(email: forgotEmailController.text.trim()).then((value) {
                      toast('Reset password link has sent your mail');
                      finish(context);
                    }).catchError((e){
                      toast(e.toString());
                    });
                  }
                },
                text: appStore.translate('send_your_password'),
                textStyle: boldTextStyle(color: white),
              ),
            ],
          ).paddingOnly(left: 16, right: 16),
        ),
      ),
    );
  }
}
