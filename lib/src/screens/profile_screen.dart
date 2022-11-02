import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ripper/src/services/firebase_auth_service.dart';
import 'package:ripper/src/validations/account_verify_validator.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../dialogs/legal_sheet.dart';
import '../extensions/locale_keys.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AccountVerifyValidationMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildCloseButton(),
            buildProfilePhoto(),
            SizedBox(
              height: 5.h,
            ),
            // buildVerifyFirstLevelIcon(),
            //   buildVerifySecondLevelIcon(),
            buildProfileButton(LocaleKeys.settings_helpsupporttext.tr(), () {
              Navigator.pushNamed(context, "/HelpSupport");
            }),
            buildProfileButton(LocaleKeys.settings_legaltext.tr(), () {
              showCupertinoModalPopup(
                  context: context,

                  //imageUrlList[index].userName
                  builder: (BuildContext context) => const LegalSheet());
            }),

            buildProfileButton(LocaleKeys.settings_logouttext.tr(), () {
              FirebaseAuthService.logoutFirebase().whenComplete(() {
                Navigator.pushReplacementNamed(context, "/LoggedOut");
              });
            }),
            buildProfileButton(LocaleKeys.settings_donetext.tr(), () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    ));
  }

  Widget buildCloseButton() {
    return Padding(
      padding: EdgeInsets.only(top: 2.5.h),
      child: Row(
        children: [
          CupertinoButton(
              child: Container(
                height: 5.2.h,
                width: 12.w,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: ColorConstants.whiteColor, width: 1.5),
                    color: ColorConstants.whiteColor),
                child: Center(
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 20.sp,
                    color: ColorConstants.blackColor,
                  ),
                ),
              ),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget buildProfilePhoto() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Container(
        decoration: const ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(width: 1.5, color: ColorConstants.themeGreen),
          ),
        ),
        child: ClipOval(
            child: Image.asset(
          "assets/images/user_default_pic.jpg",
          width: 120.sp,
          height: 120.sp,
          fit: BoxFit.cover,
        )),
      ),
    );
  }

  Widget buildProfileButton(String buttonText, Function() buttonFunc) {
    return CupertinoButton(
      onPressed: buttonFunc,
      child: Container(
        height: 6.h,
        width: 75.w,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: ColorConstants.buttonGrey,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0.2,
                blurRadius: 4.0,
                offset: Offset(0.0, 0.0))
          ],
          borderRadius: BorderRadius.circular(15.sp),
          border: Border.all(width: 3, color: ColorConstants.themeGreen),
          color: ColorConstants.whiteColor,
        ),
        child: Center(
          child: Text(buttonText,
              style: TextStyle(
                fontFamily: "Roboto-MEDIUM",
                color: ColorConstants.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 15.sp,
              )),
        ),
      ),
    );
  }

  Widget buildVerifyFirstLevelIcon() {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: validateFirstLevel(false),
    );
  }

  buildVerifySecondLevelIcon() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: validateSecondLevel(false),
    );
  }
}
