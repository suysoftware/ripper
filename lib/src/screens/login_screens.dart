// ignore_for_file: sort_child_properties_last

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/constants/decoration_constants.dart';
import 'package:ripper/src/data/user_data.dart';
import 'package:ripper/src/validations/login_validator.dart';
import 'package:sizer/sizer.dart';
import '../extensions/locale_keys.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginValidationMixin {
  var formKey = GlobalKey<FormState>();
  var user = RipperUser();

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
                      buildLoginText(),
                    ],
                  ),
                ),
                buildEmailText(),
                buildEmailField(),
                buildPasswordText(),
                buildPasswordField(),
                buildQuestionText(),

                /*    Row(
                  children: [
                    buildSignOptions("assets/images/google_icon.png",
                        LocaleKeys.loginscreen_googletext.tr()),
                    buildSignOptions("assets/images/facebook_icon.png",
                        LocaleKeys.loginscreen_facebooktext.tr()),
                  ],
                ),*/
                buildLoginButton(),
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

  Widget buildLoginText() {
    return Text(
      LocaleKeys.loginscreen_logintoptext.tr(),
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
          padding: EdgeInsets.fromLTRB(7.w, 5.h, 0.0, 0.7.h),
          child: Text(
            "Email",
            style: TextStyle(
                color: Colors.black,
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
          padding: EdgeInsets.fromLTRB(7.w, 5.h, 0.0, 0.7.h),
          child: Text(
            "Password",
            style: TextStyle(
                color: Colors.black,
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

  Widget buildQuestionText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 6.h, 0.0, 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: Image.asset("assets/images/long_tire.png")),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                LocaleKeys.loginscreen_middletext.tr(),
                style: TextStyle(
                    color: ColorConstants.blackColor,
                    fontFamily: "Roboto-LIGHT",
                    fontWeight: FontWeight.w300,
                    fontSize: 16.sp),
              ),
            ),
          ),
          Expanded(flex: 1, child: Image.asset("assets/images/long_tire.png"))
        ],
      ),
    );
  }

  Widget buildSignOptions(String assetPath, String signName) {
    return Expanded(
      child: CupertinoButton(
          child: Container(
            height: 6.h,
            width: 40.w,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Image.asset(
                    assetPath,
                    width: 8.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    signName,
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 11.sp,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: ColorConstants.fieldGrey,
              border: Border.all(color: ColorConstants.blackColor, width: 1.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          color: const Color.fromRGBO(255, 255, 255, 1),
          padding: const EdgeInsets.all(0.0),
          onPressed: () {}),
    );
  }

  Widget buildLoginButton() {
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
                LocaleKeys.loginscreen_loginbottomtext.tr(),
                style: TextStyle(
                    fontFamily: "Roboto-MEDIUM",
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.blackColor,
                    fontSize: 15.sp),
              ),
            ),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              FirebaseAuthService.loginFirebase(
                      user.userEmail, user.userPassword, context)
                  .then((value) {
                if (value != null) {
                  UserData.getUserData(value.uid, context).whenComplete(() {
               

                            Navigator.pushReplacementNamed(context, "/Alive");
         
              
                  });
                } else {}
              });
              //
              // Login checker operation
            }
          }),
    );
  }
}
