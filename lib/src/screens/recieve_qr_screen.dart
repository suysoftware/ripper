// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/screens/qr_camera_screen.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';

class RecieveQrScreen extends StatefulWidget {
  const RecieveQrScreen({super.key});

  @override
  State<RecieveQrScreen> createState() => _RecieveQrScreenState();
}

class _RecieveQrScreenState extends State<RecieveQrScreen> {
  final TextStyle bookTableTextStyle =
      TextStyle(fontFamily: "Roboto", fontSize: 10.sp);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeGreen,
        child: Container(
          decoration: backgroundDecoration(),
          height: 100.h,
          width: 100.w,
          child: (Column(
            children: [
              buildCloseButton(),
              buildQrBox(),
              buildDailyBonusButton(),
              buildTradeBookInfo(),
              buildTradeBookStream(context),
            ],
          )),
        ));
  }

  BoxDecoration backgroundDecoration() {
    return const BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/loggedoutbg.png'),
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
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
                    size: 24.sp,
                    color: ColorConstants.blackColor,
                  ),
                ),
              ),
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget buildQrBox() {
    return SizedBox(
      height: 100.h < 1200 ? 180.sp : 120.sp,
      width: 100.h < 1200 ? 180.sp : 120.sp,
      child: QrImage(
        data: context.read<RipperUserCubit>().state.userUid,
        size: 60.w,
      ),
    );
  }

  Widget buildTradeBookStream(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection('transfer_book')
              .orderBy('transferDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.hasData) {
                return Center(
                  child: CupertinoActivityIndicator(
                      animating: true, radius: 12.sp),
                );
              }
              final data = snapshot.requireData;

              return ListView.builder(
                  reverse: true,
                  itemCount: 10,
                  itemBuilder: (context, indeks) {
                    var transferAmount =
                        (data.docs[indeks]['transferAmount'] / 86400000).round();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 5.h,
                          width: 90.w,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  data.docs[indeks]['senderBookName'],
                                  style: bookTableTextStyle,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    '=>',
                                    style: bookTableTextStyle,
                                  )),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  data.docs[indeks]['recieverBookName'],
                                  style: bookTableTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "$transferAmount  Year",
                                  //'${(double.parse(data.docs[indeks]['transferAmount']) / 86400000).round()} Day',
                                  style: bookTableTextStyle,
                                ),
                              ),
                            ],
                          )),
                    );
                  });
            } else {
              return Center(
                child:
                    CupertinoActivityIndicator(animating: true, radius: 12.sp),
              );
            }
          }),
    );
  }

  Widget buildTradeBookInfo() {
    return Row(
      children: [
        Expanded(
          child: Container(
            // ignore: sort_child_properties_last
            child: Center(child: Text("From")),
            height: 4.h,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorConstants.blackColor),
                    right: BorderSide(color: ColorConstants.blackColor))),
          ),
        ),
        Expanded(
          child: Container(
            // ignore: sort_child_properties_last
            child: Center(child: Text("To")),
            height: 4.h,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorConstants.blackColor),
                    right: BorderSide(color: ColorConstants.blackColor))),
          ),
        ),
        Expanded(
          child: Container(
            // ignore: sort_child_properties_last
            child: Center(child: Text("Amount")),
            height: 4.h,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: ColorConstants.blackColor),
                    right: BorderSide(color: ColorConstants.blackColor))),
          ),
        ),
      ],
    );
  }

  Widget buildDailyBonusButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CupertinoButton(
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => QrCameraScreen()));
          },
          child: Container(
              width: 50.w,
              height: 5.h,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 0.5, spreadRadius: 0.05),
                  ],
                  color: ColorConstants.themeGreen,
                  //border: Border.all(color: ColorConstants.shadowGrey),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Image.asset('assets/images/giftbox.png'),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Daily Gift',
                    style: TextStyle(
                        fontFamily: 'Roboto-Bold', color: Colors.black),
                  )
                ],
              ))),
    );
  }
}
