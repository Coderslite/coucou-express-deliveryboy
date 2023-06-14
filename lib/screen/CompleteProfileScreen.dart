import 'package:flutter/material.dart';
import 'package:food_delivery/screen/DashboardScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:food_delivery/utils/Constants.dart';

import '../main.dart';
import '../model/UserModel.dart';
import '../utils/Common.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String tag = '/CompleteProfileScreen';
  final UserModel userModel;

  CompleteProfileScreen(this.userModel);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> update() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      widget.userModel.number = numberController.text;

      await userService.updateDocument(widget.userModel.uid, widget.userModel.toJson()).then((value) async{
        await setValue(PHONE_NUMBER, numberController.text.trim());
        DashboardScreen().launch(context,isNewTask: true);
      }).catchError((e) {
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(appStore.translate('complete_profile')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AppTextField(
                controller: numberController,
                textFieldType: TextFieldType.PHONE,
                decoration: buildInputDecoration(appStore.translate('phone_number')),
                autoFocus: true,
              ),
              16.height,
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(50)),
                width: context.width(),
                onTap: () {
                  update();
                },
                text: appStore.translate('save'),
                textStyle: boldTextStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
