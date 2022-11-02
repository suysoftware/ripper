import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/time_screen_cubit.dart';
import '../../constants/time_calculator.dart';
import '../../services/firestore_operations.dart';

class DeathScreen extends StatefulWidget {
  const DeathScreen({super.key});

  @override
  State<DeathScreen> createState() => _DeathScreenState();
}

class _DeathScreenState extends State<DeathScreen> {
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    FirestoreOperations.getRipperUser(
            // ignore: use_build_context_synchronously
            context.read<RipperUserCubit>().state.userUid)
        .then((value) {
      context.read<RipperUserCubit>().changeUser(value);

      TimeCalculator.timeGetter(value.userToken).then(
          (value) => context.read<TimeScreenCubit>().changeTimeScreen(value));

      if (context.read<RipperUserCubit>().state.userToken >
          DateTime.now().millisecondsSinceEpoch) {
        Navigator.pushReplacementNamed(context, "/HomeProvider");
      }
    });

    refreshController.refreshCompleted();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeGrey,
        child: SmartRefresher(
                        enablePullDown: true,
              enablePullUp: false,
              footer: const ClassicFooter(),
              header: const TwoLevelHeader(
                decoration: BoxDecoration(color: ColorConstants.themeGreen),
              ),
              controller: refreshController,
              onRefresh: _onRefresh,
          child: Stack(
            children: [
              Column(
                children: [
                    buildSettingsButton(),
                  buildRipperLogo(),
                  buildDeathText1(),
                  buildDeathText2(),
                  buildDeathText3(),
                  buildQrButton(),
                ],
              )
            ],
          ),
        ));
  }

  Widget buildRipperLogo() {
    return CupertinoButton(
      padding: 100.h < 1200
          ? EdgeInsets.fromLTRB(0.0, 0.h, 0.0, 0.0)
          : EdgeInsets.fromLTRB(0.0, 0.h, 0.0, 0.0),
      onPressed: () => Navigator.pushNamed(context, "/LeaderBoard"),
      child: Center(
        child: SizedBox(
          width: 30.w,
          height: 18.h,
          child: Image.asset(
            'assets/images/ripper_icon_white.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }

  Widget buildDeathText1() {
    return Padding(
      padding:
          100.h < 1200 ? EdgeInsets.only(top: 10.h) : EdgeInsets.only(top: 4.h),
      child: Text("Wait",
          style: TextStyle(
              fontFamily: "Roboto",
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 50.sp)),
    );
  }

  Widget buildDeathText2() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Text("The",
          style: TextStyle(
              fontFamily: "Roboto",
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 50.sp)),
    );
  }

  Widget buildDeathText3() {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Text("Ripper",
          style: TextStyle(
              fontFamily: "Roboto",
              color: const Color.fromRGBO(191, 239, 239, 1),
              fontSize: 50.sp)),
    );
  }

  Widget buildQrButton() {
    return Padding(
      padding: 100.h != 736.0
          ? EdgeInsets.only(top: 12.h)
          : EdgeInsets.only(top: 6.h),
      child: CupertinoButton(
          child: Image.asset("assets/images/ripper_qrcode_icon.png"),
          onPressed: () => Navigator.pushNamed(context, "/RecieveQr")),
    );
  }
    Widget buildSettingsButton() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoButton(
            child: const Icon(CupertinoIcons.info_circle_fill,
                color: ColorConstants.darkGrey),
            onPressed: () => Navigator.pushNamed(context, "/Profile"),
          )
        ],
      ),
    );
  }
}
