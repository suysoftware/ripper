import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/bloc/time_screen_cubit.dart';
import '../constants/time_calculator.dart';
import '../models/user.dart';

class RipperUserCubit extends Cubit<RipperUser> {
  RipperUserCubit() : super(RipperUser());

  void changeUser(RipperUser ripperUser) {
    emit(ripperUser);
  }

  void changeTokenValue(int sendingValue, BuildContext context) {
    var newRipperUser = RipperUser.withInfo(
        state.userUid,
        state.userName,
        state.userEmail,
        state.userPassword,
        state.userFirstVerify,
        state.userSecondVerify,
        (state.userToken - sendingValue),
        state.userPhoto,
        state.userPhone);

    TimeCalculator.timeGetter(state.userToken - sendingValue).then(
        (value) => context.read<TimeScreenCubit>().changeTimeScreen(value));

    emit(newRipperUser);
  }
}
