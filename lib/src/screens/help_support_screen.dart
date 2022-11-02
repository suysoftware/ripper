import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
// ignore: unnecessary_import, implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  String text1 =
      "Welcome to the Meta universe of the Ripper.Be careful to spend a full life that will be given to you, but don't get caught by the Ripper!";
  String text2 = "You can send or receive the time you have to others";
  String text3 =
      "In order to make transfers, you must confirm it with your mobile number.";
  String text4 = "You have to accept the rules of the Ripper's Meta universe.";
  String text5 =
      "Remember, this universe is only virtual right now, but you can be one of the Founding fathers who have already reached eternal life in the Ripper Meta universe that we will live in in the future! Take risks and Survive!";
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          automaticallyImplyLeading: true,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _sizedBox(13.h),
              buildTitleText('Ripper'),
              buildImageWidget("assets/images/ripper_intro_1.png"),
              buildRichText(text1),
              buildTitleText('Scan'),
              buildImageWidget("assets/images/ripper_intro_2.png"),
              buildRichText(text2),
              buildTitleText('Transfer'),
              buildImageWidget("assets/images/ripper_intro_3.png"),
              buildRichText(text3),
              buildTitleText('Rules'),
              buildImageWidget("assets/images/ripper_intro_4.png"),
              buildRichText(text4),
              buildTitleText('Use'),
              buildImageWidget("assets/images/ripper_intro_5.png"),
              buildRichText(text5),
              _sizedBox(10.h),
              logosWidgets(),
              _sizedBox(25.h),
            ],
          ),
        ));
  }

  Widget buildImageWidget(String assetPath) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Center(
        child: SizedBox(
            width: 60.w,
            height: 40.h,
            child: Image.asset(
              assetPath,
            )),
      ),
    );
  }

  Widget buildTitleText(String titleText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        titleText,
        style:
            GoogleFonts.orbitron(fontSize: 24.sp, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget buildRichText(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: SizedBox(
        width: 80.w,
        child: AutoSizeText.rich(
          TextSpan(
            text: content,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _sizedBox(double boxSize) {
    return SizedBox(
      height: boxSize,
    );
  }

  Widget logosWidgets() {
    return Column(
      children: [
        SizedBox(
            height: 15.h,
            width: 60.w,
            child: Image.asset('assets/images/ripper_icon.png')),
            _sizedBox(10.h),
        Text('www.ripperdev.com',style: TextStyle(color: ColorConstants.blackColor,fontFamily: 'Roboto-Light',fontSize: 11.sp),),
        const Text('_________________________'),
      _sizedBox(2.5.h),
       Text('www.dynamicgentis.com',style: TextStyle(fontFamily: 'Roboto-Light',fontSize: 11.sp),),
        _sizedBox(10.h),
        SizedBox(
            width: 25.w,
            child: Image.asset('assets/images/dynamic_gentis_logo_head.png')),
        _sizedBox(3.h),
        SizedBox(
            width: 40.w,
            child:
                Image.asset('assets/images/dynamic_gentis_text_logo_dark.png')),
      ],
    );
  }
}
