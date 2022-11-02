import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:ripper/src/bloc/time_screen_cubit.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/services/firestore_operations.dart';
import 'package:sizer/sizer.dart';
import '../constants/time_calculator.dart';
import '../extensions/locale_keys.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    addSlide(
      "assets/images/ripper_intro_1.png",
      LocaleKeys.introscreen_slide1descriptiontext.tr(),
    );
    addSlide(
      "assets/images/ripper_intro_2.png",
      LocaleKeys.introscreen_slide2descriptiontext.tr(),
    );
    addSlide(
      "assets/images/ripper_intro_3.png",
      LocaleKeys.introscreen_slide3descriptiontext.tr(),
    );
    addSlide(
      "assets/images/ripper_intro_4.png",
      LocaleKeys.introscreen_slide4descriptiontext.tr(),
    );
    addSlide(
      "assets/images/ripper_intro_5.png",
      LocaleKeys.introscreen_slide5descriptiontext.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      showSkipBtn: false,
      showPrevBtn: false,

      renderSkipBtn: renderSkipBtn(),
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      nextButtonStyle: myButtonStyle(),

      renderDoneBtn: renderDoneBtn(),
      onDonePress: () {
        showCupertinoDialog(
            context: context,
            builder: (context) => const CupertinoAlertDialog(
                  title: Text("Please Wait, Ripper Calculating Your Time"),
                  content: CupertinoActivityIndicator(animating: true),
                ));
        Future.delayed(const Duration(seconds: 7), () {
          var userAuth = FirebaseAuth.instance;
          FirestoreOperations.getRipperUser(userAuth.currentUser!.uid)
              .then((value) {
            context.read<RipperUserCubit>().changeUser(value);

            TimeCalculator.timeGetter(value.userToken).then((value) =>
                context.read<TimeScreenCubit>().changeTimeScreen(value));

            Navigator.pushReplacementNamed(context, "/HomeProvider");
          });
        });
      },
      doneButtonStyle: myButtonStyle(),
      // Dot indicator
      colorDot: const Color(0x33FFA8B0),
      colorActiveDot: const Color(0xffFFA8B0),
      sizeDot: 13.0,
      // Show or hide status bar
      hideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFA8B0)),
    );
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Color(0xffF3B4BA),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Color(0xffF3B4BA),
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Color(0xffF3B4BA),
    );
  }

  void addSlide(String imagePath, String slideText) {
    slides.add(Slide(
        marginTitle: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 3.h),
        styleDescription: TextStyle(
            shadows: [
              Shadow(
                  offset: const Offset(1.5, 1.0),
                  color: ColorConstants.blackColor,
                  blurRadius: 2.sp),
            ],
            color: ColorConstants.themeGreen,
            fontFamily: "Roboto-Medium",
            fontSize: 18.sp),
        description: slideText,
        pathImage: imagePath,
        widthImage: 50.w,
        heightImage: 50.h,
        backgroundColor: ColorConstants.whiteColor));
  }
}
