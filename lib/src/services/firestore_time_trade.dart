import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ripper/src/dialogs/error_dialog.dart';
import '../models/user.dart';

class FirestoreTimeTrade {
  static Future<bool> uidCheckerForTrade(
    String recieverUid,
  ) async {
    var checkResult = false;
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('users').get();
    final List<DocumentSnapshot> documents = result.docs;

    // ignore: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
    documents.forEach((DOC) {
      if (DOC.id == recieverUid) {
        checkResult = true;
      }
    });
    return checkResult;
  }

  static Future<void> tradeFirstStep(RipperUser ripperUser, String recieverUid,
      int? transferAmount, BuildContext context) async {
    // ignore: unused_local_variable
    var dateNow = DateTime.now();

    uidCheckerForTrade(recieverUid).then((value) {
      if (value == true) {
        timeSender(ripperUser, recieverUid, transferAmount, context);
      } else {
        ErrorDialogs.errorDialog("Qr Not Exist", context);
      }
    });
  }

  static Future<void> timeSender(RipperUser ripperUser, String recieverUid,
      int? transferAmount, BuildContext context) async {
    var dateNow = DateTime.now();

    FirebaseFirestore.instance.collection("transfers").doc().set({
      "recieverUid": recieverUid,
      "senderUid": ripperUser.userUid,
      "transferDate": dateNow,
      "transferAmount": transferAmount
    });
  }

  static Future<void> giftRequest(RipperUser ripperUser, String qrNo,
      [GeoPoint? userLocation]) async {
    var dateNow = DateTime.now();
    var onlyGiftNo = qrNo.substring(0, 20);
    FirebaseFirestore.instance.collection("gift_requests").doc().set({
      "gift_no": onlyGiftNo,
      "request_time": dateNow,
      // ignore: prefer_const_constructors
      "requester_location": userLocation ?? GeoPoint(31.2, 32.1),
      "requester_uid": ripperUser.userUid,
    });
  }

  static Future<void> betOperation(
      RipperUser ripperUser, String qrNo, int betAmount) async {

    var targetGameNo = qrNo.substring(0, 20);
    var userName = ripperUser.userEmail.substring(0, 5);



    FirebaseFirestore.instance.collection("bet_pool").doc().set({
      "betAmount": betAmount,
      "playerName": userName,
      "playerUid": ripperUser.userUid,
      "playerPhoto": ripperUser.userPhoto,
      "betDate":DateTime.now().millisecond,
      "targetGameNo": targetGameNo
    });
  }
}
