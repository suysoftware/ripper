import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/constants/color_constants.dart';
import 'package:ripper/src/services/firestore_time_trade.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../extensions/locale_keys.dart';

class QrCameraScreen extends StatefulWidget {
  const QrCameraScreen({
    Key? key,
    this.sendingAmount,
  }) : super(key: key);
  final int? sendingAmount;

  @override
  State<QrCameraScreen> createState() => _QrCameraScreenState();
}

class _QrCameraScreenState extends State<QrCameraScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  int sendAmount = 0;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
      controller!.flipCamera();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.sendingAmount != null) {
      sendAmount = widget.sendingAmount!;
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeGreen,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          elevation: 0.0,
          child: dialogContent(context),
        ));
  }

  Stack _stack(BuildContext context) {
    return Stack(
      children: [
        _buildQrView(context),
        if (result != null) _buildRoundedLoadingButton(sendAmount),
      ],
    );
  }

  dialogContent(BuildContext context) {
    return Scaffold(
      body: _stack(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.

    // ignore: unused_local_variable
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    // var scanArea = 50.w;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          cameraFacing: CameraFacing.back,
          overlayMargin: EdgeInsets.zero,
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 35.sp,
              borderLength: 35,
              borderWidth: 25,
              cutOutSize: 70.w),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Positioned(
          left: 7.w,
          top: 7.h,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 30.sp,
            ),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Widget _buildRoundedLoadingButton(int sendAmount) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RoundedLoadingButton(
          width: 50.w,
          height: 10.h,
          controller: _btnController,
          color: Colors.transparent,
          successColor: Colors.lightGreenAccent,
          failedIcon: Icons.warning,
          errorColor: Colors.red,
          successIcon: Icons.assignment_turned_in,
          onPressed: () {
            if ('${result!.code}'.length > 10) {
              var sendingAmountMilliseconds = sendAmount * 86400000;

              if (widget.sendingAmount == null) {
                //Thats gift
                if ('${result!.code}'.endsWith('//RIPPER-GIFT')) {
                  FirestoreTimeTrade.giftRequest(
                    context.read<RipperUserCubit>().state,
                    '${result!.code}',
                  ).whenComplete(() {
                    _btnController.success();
                    Timer(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                    });
                  });
                } else {
                  _btnController.error();
                  Timer(const Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                }
              } else {
                if ('${result!.code}'.endsWith('//RIPPER-GIFT')) {
                  FirestoreTimeTrade.giftRequest(
                    context.read<RipperUserCubit>().state,
                    '${result!.code}',
                  ).whenComplete(() {
                    _btnController.success();
                    Timer(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                    });
                  });
                } else if ('${result!.code}'.endsWith('//RIPPER-ROULETTE')) {
                  if (context.read<RipperUserCubit>().state.userToken >
                      sendingAmountMilliseconds) {
                    FirestoreTimeTrade.betOperation(
                      context.read<RipperUserCubit>().state,
                      result!.code!,
                      sendingAmountMilliseconds,
                    ).whenComplete(() {
                      _btnController.success();
                      context
                          .read<RipperUserCubit>()
                          .changeTokenValue(sendingAmountMilliseconds, context);
                      Timer(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                      });
                    });
                  }
                } else {
                  if (context.read<RipperUserCubit>().state.userToken >
                      sendingAmountMilliseconds) {
                    FirestoreTimeTrade.tradeFirstStep(
                            context.read<RipperUserCubit>().state,
                            result!.code!,
                            sendingAmountMilliseconds,
                            context)
                        .whenComplete(() {
                      _btnController.success();
                      context
                          .read<RipperUserCubit>()
                          .changeTokenValue(sendingAmountMilliseconds, context);
                      Timer(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                      });
                    });
                  }
                }
              }
            } else {
              _btnController.error();
              Timer(const Duration(seconds: 3), () {
                Navigator.pop(context);
              });
            }
          },
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Text(LocaleKeys.amountdialog_sendtimetext.tr(),
                style: TextStyle(
                    fontFamily: "Roboto-Medium",
                    fontSize: 16.sp,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
