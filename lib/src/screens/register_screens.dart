import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:ripper/src/screens/legals/terms_of_use.dart';
import 'package:ripper/src/services/firebase_auth_service.dart';
import 'package:ripper/src/validations/register_validator.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../constants/decoration_constants.dart';
import '../extensions/locale_keys.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with RegisterValidationMixin, TickerProviderStateMixin {
  var formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<double> checkBoxOpacity;
  bool checkbox = false;
  bool checkBoxAlert = false;
  var user = RipperUser();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    checkBoxOpacity = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                //BackButton and LoginText is here
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      buildBackButton(),
                      buildRegisterText(),
                    ],
                  ),
                ),
                buildNameText(),
                buildNameField(),
                buildEmailText(),
                buildEmailField(),
                buildPasswordText(),
                buildPasswordField(),
                buildTermCheck(),
                buildRegisterButton(),
              ],
            ),
          ),
        ));
  }

  Widget buildBackButton() {
    return CupertinoButton(
        child: Container(
          height: 5.2.h,
          width: 12.w,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ColorConstants.blackColor, width: 1.5),
              color: ColorConstants.themeGreen),
          child: Center(
            child: Icon(
              CupertinoIcons.back,
              size: 20.sp,
              color: ColorConstants.blackColor,
            ),
          ),
        ),
        onPressed: () => Navigator.pop(context));
  }

  Widget buildRegisterText() {
    return Text(
      LocaleKeys.registerscreen_signuptext.tr(),
      style: TextStyle(
        fontFamily: "Roboto-BOLD",
        fontSize: 30.sp,
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      decoration: DecorationConstants.fieldBoxDecoration,
      height: 9.h,
      width: 80.w,
      child: Center(
        child: CupertinoTextFormFieldRow(
          validator: validateEmail,
          onSaved: (String? value) {
            if (value != null) {
              user.userEmail = value;
            }
          },
          cursorColor: ColorConstants.blackColor,
          placeholderStyle: TextStyle(
              color: ColorConstants.fieldTextGrey,
              fontSize: 12.sp,
              fontFamily: "Roboto-LIGHT"),
          placeholder: "Enter your Email",
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(7.w, 3.h, 0.0, 0.7.h),
          child: Text(
            "Email",
            style: TextStyle(
                color: ColorConstants.blackColor,
                fontSize: 12.sp,
                fontFamily: "Roboto-LIGHT"),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordText() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(7.w, 3.h, 0.0, 0.7.h),
          child: Text(
            "Password",
            style: TextStyle(
                color: ColorConstants.blackColor,
                fontSize: 11.sp,
                fontFamily: "Roboto-LIGHT"),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Container(
      decoration: DecorationConstants.fieldBoxDecoration,
      height: 9.h,
      width: 80.w,
      child: CupertinoTextFormFieldRow(
        onSaved: (String? value) {
          if (value != null) {
            user.userPassword = value;
          }
        },
        cursorColor: ColorConstants.blackColor,
        obscureText: true,
        validator: validatePassword,
        obscuringCharacter: "*",
        placeholder: "Enter your Password",
        placeholderStyle: TextStyle(
            color: ColorConstants.fieldTextGrey,
            fontSize: 11.sp,
            fontFamily: "Roboto-LIGHT"),
      ),
    );
  }

  Widget buildRegisterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 4.h, 0.0, 0.0),
      child: CupertinoButton(
          child: Container(
            width: 80.w,
            height: 6.h,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: ColorConstants.themeGreen,
                borderRadius: BorderRadius.circular(15.0),
                border:
                    Border.all(color: ColorConstants.blackColor, width: 3.0)),
            child: Center(
              child: Text(
                LocaleKeys.registerscreen_createaccounttext.tr(),
                style: TextStyle(
                    fontFamily: "Roboto-MEDIUM",
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.blackColor,
                    fontSize: 15.sp),
              ),
            ),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate() && checkbox == true) {
              formKey.currentState!.save();

              await FirebaseAuthService.registerFirebase(
                      user.userName, user.userEmail, user.userPassword, context)
                  .then((value) {
                if (value != null) {
                  Navigator.pushReplacementNamed(context, "/Intro");
                } else {
                }
              });

              //
              // Login checker operation
            } else if (formKey.currentState!.validate() && checkbox == false) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        actions: [
                          CupertinoButton(
                              child: const Text("OKAY"),
                              onPressed: () => Navigator.pop(context))
                        ],
                        content: const Text("Accept Our Rules!"),
                      ));
              setState(() {
                checkBoxAlert = true;
              });
            }
          }),
    );
  }

  Widget buildNameText() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(7.w, 5.h, 0.0, 0.7.h),
          child: Text(
            "Name",
            style: TextStyle(
                color: ColorConstants.blackColor,
                fontSize: 11.sp,
                fontFamily: "Roboto-LIGHT"),
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return Container(
      decoration: DecorationConstants.fieldBoxDecoration,
      height: 9.h,
      width: 80.w,
      child: Center(
        child: CupertinoTextFormFieldRow(
          validator: validateName,
          onSaved: (String? value) {
            if (value != null) {
              user.userName = value;
            }
          },
          cursorColor: ColorConstants.blackColor,
          placeholderStyle: TextStyle(
              color: ColorConstants.fieldTextGrey,
              fontSize: 12.sp,
              fontFamily: "Roboto-LIGHT"),
          placeholder: "Enter your Nickname",
        ),
      ),
    );
  }

  Widget buildTermCheck() {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TermsOfUse(),
          GestureDetector(
            onTap: () {
              checkBox();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 6.w,
                  width: 6.w,
                  child: Container(
                      // ignore: sort_child_properties_last
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Opacity(
                            opacity: checkBoxOpacity.value,
                            // ignore: prefer_const_constructors
                            child: Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: ColorConstants.blackColor,
                            )),
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: checkBoxAlert
                                  ? ColorConstants.redAlert
                                  : ColorConstants.blackColor,
                              width: checkBoxAlert ? 3.0 : 1.0)))),
            ),
          ),
        ],
      ),
    );
  }

  checkBox() {
    if (animationController.isCompleted) {
      animationController.reverse();
      checkbox = false;
      checkBoxAlert = true;
    } else {
      animationController.forward();
      checkbox = true;
      checkBoxAlert = false;
    }
  }
}
