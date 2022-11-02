import 'package:circular_menu/circular_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ripper/src/bloc/time_screen_cubit.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/constants/time_calculator.dart';
import 'package:ripper/src/dialogs/amount_dialog.dart';
import 'package:ripper/src/extensions/locale_keys.dart';
import 'package:ripper/src/models/time_screen_models.dart';
import 'package:sizer/sizer.dart';

import '../../services/firestore_operations.dart';

class AliveScreen extends StatefulWidget {
  const AliveScreen({super.key});

  @override
  State<AliveScreen> createState() => _AliveScreenState();
}

class _AliveScreenState extends State<AliveScreen>
    with TickerProviderStateMixin {
  GlobalKey<CircularMenuState> circularMenuKey = GlobalKey<CircularMenuState>();
  bool cycleBool = true;

  Future<void> cycleOperation() async {
    if (cycleBool == true) {
      Future.delayed(const Duration(seconds: 1), () async {
        await TimeCalculator.timeGetter(
                context.read<RipperUserCubit>().state.userToken)
            .then((value) =>
                context.read<TimeScreenCubit>().changeTimeScreen(value));

        setState(() {});
      });
    }
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // ignore: use_build_context_synchronously
    FirestoreOperations.getRipperUser(
            context.read<RipperUserCubit>().state.userUid)
        .then((value) {
      context.read<RipperUserCubit>().changeUser(value);

      TimeCalculator.timeGetter(value.userToken).then(
          (value) => context.read<TimeScreenCubit>().changeTimeScreen(value));
    });
    // monitor network fetch
    // print("onrefresh");
    //
    // if failed,use refreshFailed()
    /* await getUserAllFromDataBase(widget.userAll.isolaUserMeta.userUid)
        .then((value) {
      context.read<UserAllCubit>().userAllChanger(value);
      context.read<GroupMergeCubit>().groupMergeUserAllChanger(value);
    });
    setState(() {
      //  print("111");
      //  isRefresh = true;
      //itemCountValue = 20;
      userAll = context.read<UserAllCubit>().state;
    });*/

    refreshController.refreshCompleted();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cycleBool = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<RipperUserCubit>().state.userToken >
        DateTime.now().millisecondsSinceEpoch) {
      cycleOperation();
    }

    return CupertinoPageScaffold(
        child: SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      footer: const ClassicFooter(),
      header: const TwoLevelHeader(
        decoration: BoxDecoration(color: ColorConstants.themeGreen),
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      child: Stack(children: [
        BlocBuilder<TimeScreenCubit, TimeScreenModels>(
            builder: (context, snapshot) {
          return Column(
            children: [
              buildSettingsButton(),
              buildRipperLogo(),
              buildTimeText(
                  numberTextSize: 60.sp,
                  textSize: 45.sp,
                  timeType: LocaleKeys.timegiverscreen_yeartext.tr(),
                  timeValue: snapshot.year,
                  topPadding: 100.h < 1200 ? 4.h : 1.4.h),
              buildTimeText(
                  numberTextSize: 40.sp,
                  textSize: 35.sp,
                  timeType: LocaleKeys.timegiverscreen_monthtext.tr(),
                  timeValue: snapshot.month,
                  topPadding: 100.h < 1200 ? 2.4.h : 0.2.h),
              buildTimeText(
                  numberTextSize: 33.sp,
                  textSize: 27.sp,
                  timeType: LocaleKeys.timegiverscreen_daytext.tr(),
                  timeValue: snapshot.day,
                  topPadding: 100.h < 1200 ? 2.4.h : 1.7),
              buildTimeText(
                  numberTextSize: 27.sp,
                  textSize: 20.sp,
                  timeType: LocaleKeys.timegiverscreen_hourtext.tr(),
                  timeValue: snapshot.hour,
                  topPadding: 100.h < 1200 ? 2.h : 1.2.h),
              buildTimeText(
                  numberTextSize: 18.sp,
                  textSize: 14.sp,
                  timeType: LocaleKeys.timegiverscreen_minutetext.tr(),
                  timeValue: snapshot.minute,
                  topPadding: 100.h < 1200 ? 1.8.h : 1.5.h),
              buildTimeText(
                  numberTextSize: 11.sp,
                  textSize: 9.sp,
                  timeType: LocaleKeys.timegiverscreen_secondtext.tr(),
                  timeValue: snapshot.second,
                  topPadding: 100.h < 1200 ? 2.5.h : 1.7),
              buildCircularMenu(),
            ],
          );
        }),
      ]),
    ));
  }

  Widget buildRipperLogo() {
    return CupertinoButton(
      padding: 100.h < 1200
          ? EdgeInsets.fromLTRB(0.0, 1.h, 0.0, 0.0)
          : EdgeInsets.fromLTRB(0.0, 0.h, 0.0, 0.0),
      onPressed: () => Navigator.pushNamed(context, "/LeaderBoard"),
      child: Center(
        child: SizedBox(
          width: 30.w,
          height: 18.h,
          child: Image.asset(
            'assets/images/ripper_icon_grey.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }

  Widget buildTimeText(
      {required String timeType,
      required double textSize,
      required double numberTextSize,
      required int timeValue,
      required double topPadding}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeValue.toString(),
            style: TextStyle(fontFamily: "Roboto", fontSize: numberTextSize),
          ),
          Text(
            timeType,
            style: TextStyle(fontFamily: "Roboto", fontSize: textSize),
          ),
        ],
      ),
    );
  }

  Widget buildCircularMenu() {
    return Padding(
      padding:
          100.h < 1200 ? EdgeInsets.only(top: 6.h) : EdgeInsets.only(top: 2.h),
      child: CircularMenu(
          radius: 80.sp,
          key: circularMenuKey,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceInOut,
          toggleButtonMargin: 1.sp,
          toggleButtonSize: 50.sp,
          //backgroundWidget: CupertinoButton(onPressed: (){},child: Icon(CupertinoIcons.add)),
          backgroundWidget: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.whiteColor),
                  borderRadius: BorderRadius.all(Radius.circular(30.sp)),
                  color: ColorConstants.transparent),
              height: 10.h,
              width: 80.w,
              child: Image.asset("assets/images/ripper_qrcode_icon.png")),
          toggleButtonColor: ColorConstants.transparent,
          toggleButtonIconColor: ColorConstants.transparent,
          startingAngleInRadian: 0.01,
          endingAngleInRadian: 9.39,
          items: [
            buildCircularMenuItem(
                // ignore: prefer_const_constructors
                Icon(
                  Icons.call_received,
                ),
                true,
                true,
                () => Navigator.pushNamed(context, "/RecieveQr"),
                Colors.greenAccent.shade400),
            buildCircularMenuItem(const Icon(Icons.call_made), true, true, () {
              showModalBottomSheet(
                  backgroundColor: ColorConstants.transparent,
                  context: context,
                  builder: (context) => const AmountDialog());
            }, ColorConstants.redAlert),
          ]),
    );
  }

  CircularMenuItem buildCircularMenuItem(Icon icon, bool firstAccess,
      bool secondAccess, Function onTapFunction, Color iconColor) {
    return CircularMenuItem(
        boxShadow: const [BoxShadow(color: ColorConstants.buttonGrey)],
        iconSize: 35.sp,
        padding: 1.h,
        enableBadge: firstAccess != true || secondAccess != true ? true : false,
        badgeColor: ColorConstants.redAlert,
        badgeLabel: 'X',
        badgeRadius: 3.w,
        color: ColorConstants.fieldGrey,
        iconColor: iconColor,
        badgeTextColor: ColorConstants.themeGreen,
        badgeTextStyle: const TextStyle(fontFamily: "Roboto"),
        badgeLeftOffet: 14.w,
        badgeBottomOffet: 7.h,
        icon: icon.icon,
        onTap: () {
          onTapFunction();
        });
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
