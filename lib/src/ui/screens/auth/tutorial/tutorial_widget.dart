import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim23/src/resources/colors.dart';
import 'package:sim23/src/resources/const.dart';
import 'package:sim23/src/resources/drawables.dart';
import 'package:sim23/src/resources/strings.dart';
import 'package:sim23/src/router/app_routing_names.dart';
import 'package:sim23/src/ui/screens/auth/tutorial/tutorial_screen.dart';

class TutorialWidget extends State<TutorialScreen> {
  static const TUTORIAL_PAGE_AMOUNT = 3;
  ScrollController pageController;
  int _currentPage;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand_grey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 88),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              child: Container(
                color: AppColors.bg_light_grey,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: FittedBox(
              child: Drawables.getImage(Drawables.RECTANGLE_BACKGROUND),
              fit: BoxFit.fill,
            ),
          ),
          _buildPageView(),
          Align(alignment: Alignment.bottomCenter, child: _buildBottomButtons())
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: PageIndicatorContainer(
          length: 3,
          align: IndicatorAlign.bottom,
          indicatorColor: AppColors.bg_light_grey_20,
          padding: const EdgeInsets.only(left: 5, right: 5, top: 12),
          shape: IndicatorShape.circle(size: 6),
          indicatorSelectorColor: AppColors.brand_yellow,
          child: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (int page) => {
              setState(() {
                _currentPage = page;
              })
            },
            controller: pageController,
            children: <Widget>[
              _buildTutorialPage(1),
              _buildTutorialPage(2),
              _buildTutorialPage(3),
            ],
          )),
    );
  }

  Widget _buildTutorialPage(int pos) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Drawables.getImage(
              Drawables.TUTORIAL_PAGE_ + pos.toString() + Drawables.PNG),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
            child: Text(
              Strings.get(context, Strings.TUTORIAL_TITLE_ + pos.toString()),
              style: TextStyle(
                  color: AppColors.solid_black,
                  fontFamily: Const.FONT_FAMILY_NUNITO,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 44),
              child: Text(
                Strings.get(
                    context, Strings.TUTORIAL_DESCRIPTION_ + pos.toString()),
                style: TextStyle(
                    color: AppColors.solid_black_60,
                    fontSize: 14,
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ))
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: finishTutorial,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 32, right: 32, top: 8, bottom: 8),
                color: AppColors.transparent,
                child: Text(
                  Strings.get(context, Strings.SKIP),
                  style: TextStyle(
                      color: AppColors.white_60,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              if ((_currentPage + 1) < TUTORIAL_PAGE_AMOUNT)
                {
                  pageController.animateTo(
                      MediaQuery.of(context).size.width * (_currentPage + 1),
                      duration: new Duration(milliseconds: 300),
                      curve: Curves.easeIn)
                }
              else
                {finishTutorial()}
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.transparent,
              child: Text(
                Strings.get(
                    context,
                    (_currentPage + 1) == TUTORIAL_PAGE_AMOUNT
                        ? Strings.AUTHORIZE
                        : Strings.NEXT),
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontFamily: Const.FONT_FAMILY_NUNITO,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Drawables.getImage(Drawables.ARROW_RIGHT),
          )
        ],
      ),
    );
  }

  void finishTutorial() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool(Const.MAIN_TUTORIAL_COMPLETED, true);
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.LOGIN_SCREEN, (Route<dynamic> route) => false);
  }
}
