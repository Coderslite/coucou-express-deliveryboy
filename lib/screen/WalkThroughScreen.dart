import 'package:flutter/material.dart';
import 'package:food_delivery/model/WalkThroughModel.dart';
import 'package:food_delivery/screen/LoginScreen.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/utils/Common.dart';
import 'package:food_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  List<WalkThroughModel> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.white, delayInMilliSeconds: 100);

    list.add(WalkThroughModel(
      title: 'Browse the menu and order directly from \n the application',
      image: 'images/WalkThrough1.png',
    ));
    list.add(WalkThroughModel(
      title: 'Your order will be immediately collected and \n send by our courier',
      image: 'images/WalkThrough2.png',
    ));
    list.add(WalkThroughModel(
      title: 'Pick up delivery at your door and enjoy \n groceries',
      image: 'images/WalkThrough3.png',
    ));
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
            PageView(
              controller: pageController,
              onPageChanged: (index) {},
              children: list.map((e) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonCachedNetworkImage(e.image, fit: BoxFit.cover, height: 200),
                    22.height,
                    Text(e.title!, style: boldTextStyle(size: 20), textAlign: TextAlign.center),
                    8.height,
                    Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                        style: secondaryTextStyle(size: 14),
                        textAlign: TextAlign.center),
                  ],
                );
              }).toList(),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text('skip'),
                    decoration: boxDecorationRoundedWithShadow(30),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  ).onTap(() async {
                    await setValue(IS_FIRST_TIME, false);

                    LoginScreen().launch(context, isNewTask: true);
                  }),
                  DotIndicator(
                    indicatorColor: primaryColor,
                    pageController: pageController,
                    pages: list,
                    unselectedIndicatorColor: Colors.grey,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                  Container(
                    child: Text(currentPage != 2 ? 'next' : 'finish'),
                    decoration: boxDecorationRoundedWithShadow(30),
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  ).onTap(() async {
                    if (currentPage == 2) {
                      await setValue(IS_FIRST_TIME, false);

                      LoginScreen().launch(context, isNewTask: true);
                    } else {
                      pageController.animateToPage(currentPage + 1, duration: Duration(milliseconds: 300), curve: Curves.linear);
                    }
                  }),
                ],
              ).paddingOnly(left: 16, right: 16),
            ),
          ],
        ),
      ),
    );
  }
}
