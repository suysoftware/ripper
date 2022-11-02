import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../extensions/locale_keys.dart';

class LoggedOutScreen extends StatefulWidget {
  const LoggedOutScreen({super.key});

  @override
  State<LoggedOutScreen> createState() => _LoggedOutScreenState();
}

class _LoggedOutScreenState extends State<LoggedOutScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeGreen,
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: backgroundDecoration(),
          child: Column(
            children: [
              buildRipperLogo(),
              buildLoginButton(),
              buildQuestionText(),
              buildRegisterButton(),
            ],
          ),
        ));
  }

  BoxDecoration backgroundDecoration() {
    return const BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/loggedoutbg.png'),
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
    ));
  }

  Widget buildRipperLogo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.h, 0.0, 0.0),
      child: SizedBox(
        width: 40.w,
        height: 25.h,
        child: Image.asset(
          'assets/images/ripper_icon_grey.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 24.h, 0.0, 0.0),
      child: CupertinoButton(
          child: Container(
            width: 80.w,
            height: 6.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: ColorConstants.transparent,
                borderRadius: BorderRadius.circular(15.0),
                border:
                    Border.all(color: ColorConstants.blackColor, width: 3.0)),
            child: Center(
              child: Text(
                LocaleKeys.firstscreen_logintext.tr(),
                style: TextStyle(
                    fontFamily: "Roboto-MEDIUM",
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(49, 49, 49, 1),
                    fontSize: 15.sp),
              ),
            ),
          ),
          onPressed: () => Navigator.pushNamed(context, "/Login")),
    );
  }

  Widget buildQuestionText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 3.h, 0.0, 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: Image.asset("assets/images/long_tire.png")),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                LocaleKeys.firstscreen_middletext.tr(),
                style: TextStyle(
                    color: ColorConstants.blackColor,
                    fontFamily: "Roboto-LIGHT",
                    fontWeight: FontWeight.w300,
                    fontSize: 13.sp),
              ),
            ),
          ),
          Expanded(flex: 1, child: Image.asset("assets/images/long_tire.png"))
        ],
      ),
    );
  }

  Widget buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: CupertinoButton(
          child: Container(
            width: 80.w,
            height: 6.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: ColorConstants.buttonGrey,
                borderRadius: BorderRadius.circular(15.0),
                border:
                    Border.all(color: ColorConstants.blackColor, width: 1.0)),
            child: Center(
              child: Text(
                LocaleKeys.firstscreen_registertext.tr(),
                style: TextStyle(
                    fontFamily: "Roboto-MEDIUM",
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.blackColor,
                    fontSize: 15.sp),
              ),
            ),
          ),
          onPressed: () 
           =>Navigator.pushNamed(context, "/Register")
          ),
    );
  }
}
