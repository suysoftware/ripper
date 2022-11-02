import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/dialogs/error_dialog.dart';
import 'package:ripper/src/screens/qr_camera_screen.dart';
import 'package:sizer/sizer.dart';
import '../bloc/time_screen_cubit.dart';
import '../extensions/locale_keys.dart';

class AmountDialog extends StatefulWidget {
  const AmountDialog({super.key});

  @override
  State<AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<AmountDialog> {
  String ansStr = "";
  late int _currentlyTokenValue;
  TextEditingController t1 = TextEditingController();

  @override
  void initState() {
    super.initState();

    _currentlyTokenValue =
        context.read<TimeScreenCubit>().state.tradeAvailableDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      decoration: const BoxDecoration(
          color: ColorConstants.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
      child: Column(
        //    mainAxisSize: MainAxisSize.min,
        children: [
          buildCloseButton(),
          buildHowManyText(),
          _sizedBox(1.0),
          amountTextBox(),
          _sizedBox(2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _whichPlatform(
                "1",
              ),
              _whichPlatform(
                "2",
              ),
              _whichPlatform(
                "3",
              ),
            ],
          ),
          _sizedBox(2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _whichPlatform(
                "4",
              ),
              _whichPlatform(
                "5",
              ),
              _whichPlatform(
                "6",
              ),
            ],
          ),
          _sizedBox(2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _whichPlatform(
                "7",
              ),
              _whichPlatform(
                "8",
              ),
              _whichPlatform(
                "9",
              ),
            ],
          ),
          _sizedBox(2.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _whichPlatform(
                "c",
              ),
              _whichPlatform(
                "0",
              ),
              _whichPlatform(
                "✔",
              ),
            ],
          ),
          _sizedBox(1.0),
          buildAvailableDay(),
          _sizedBox(1.0),
        ],
      ),
    );
  }

  Widget _androidButton(String number, Color? color) {
    // Creating a method of return type Widget with number and function f as a parameter
    return MaterialButton(
      height: 100.0,
      textColor: Colors.black,
      color: color,
      onPressed: amountWriterFunction(number),
      child: Text(number,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
    );
  }

  Widget _iosButton(String number, Color? color) {
    // Creating a method of return type Widget with number and function f as a parameter

    return Container(
      height: 5.h,
      width: 19.w,
      decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: const Color.fromRGBO(126, 126, 126, 0.1),
          ),
          borderRadius: BorderRadius.circular(11.0),
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(126, 126, 126, 0.4),
                blurRadius: 4,
                spreadRadius: 0.2,
                offset: Offset(-2, 2))
          ]),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: color,
        child: Text(
          number,
          style: TextStyle(
              fontFamily: 'Roboto-Light',
              color: Colors.black,
              fontSize: 100.h < 1200 ? 20.sp : 16.sp),
        ),
        onPressed: () => amountWriterFunction(number),
      ),
    );
  }

  amountWriterFunction(String number) {
    switch (number) {
      case "c":
        setState(() {
          ansStr = "";
        });
        break;
      case "✔":
        if (ansStr.isNotEmpty) {
          int sendingAmount = int.parse(ansStr);

          if (_currentlyTokenValue > sendingAmount) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        QrCameraScreen(sendingAmount: sendingAmount)));
          } else {
            ErrorDialogs.errorDialog(
                'You have not $sendingAmount Days', context);
          }
        }

        break;
      //complate

      default:
        if (ansStr.length <= 7) {
          // ignore: prefer_is_empty
          if (ansStr.length == 0 && number == "0") {
          } else {
            setState(() {
              ansStr += number;
            });
          }
        }
    }
  }

  Widget _whichPlatform(String number) {
    Color color =
        number == "✔" ? ColorConstants.themeGreen : ColorConstants.whiteColor;
    if (Platform.isIOS) {
      return _iosButton(number, color);
    } else {
      return _androidButton(number, color);
    }
  }

  Widget _sizedBox(double carpan) {
    return SizedBox(
      height: carpan.h,
    );
  }

  Widget buildAvailableDay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 80.w,
          height: 5.h,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(126, 126, 126, 0.12),
                  blurRadius: 4,
                  spreadRadius: 0.2,
                  offset: Offset(-2, 2))
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Text(
            '${LocaleKeys.amountdialog_availabledays.tr()}$_currentlyTokenValue',
            style: TextStyle(
                letterSpacing: 0.5,
                fontFamily: "Roboto-Light",
                fontSize: 15.sp),
          ),
        )
      ],
    );
  }

  Widget buildCloseButton() {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 27.sp,
            ),
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget buildHowManyText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.amountdialog_howmanytext.tr(),
          style: const TextStyle(fontFamily: "Roboto"),
        )
      ],
    );
  }

  Widget amountTextBox() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      constraints: BoxConstraints.expand(width: 80.w, height: 7.h),

      alignment: Alignment
          .center, // Aligning the text to the bottom right of our display screen

      child: Text(
        ansStr,
        style: TextStyle(
            // Styling the text
            fontSize: 25.sp,
            color: Colors.black),
        textAlign: TextAlign.right,
      ),
    );
  }
}
