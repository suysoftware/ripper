import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import '../bloc/time_screen_cubit.dart';
import '../constants/time_calculator.dart';
import '../models/user.dart';

class UserData {
  static Future getUserData(String userUid, BuildContext context) async {
    var userInfo = RipperUser();
   await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .get()
        .then((userValue) {
      userInfo.userUid = userValue['user_uid'];
      userInfo.userName = userValue['user_name'];
      userInfo.userEmail = userValue['user_email'];
      userInfo.userPassword = userValue['user_password'];
      userInfo.userFirstVerify = userValue['user_first_verify'];
      userInfo.userSecondVerify = userValue['user_second_verify'];
      userInfo.userToken = userValue['user_token'];
      userInfo.userPhoto = userValue['user_photo'];
      userInfo.userPhone = userValue['user_phone'];
    }).whenComplete(() {

    TimeCalculator.timeGetter(userInfo.userToken).then((value) {
      context.read<TimeScreenCubit>().changeTimeScreen(value);


      context.read<RipperUserCubit>().changeUser(userInfo);
    });

    });

  
  }
}
