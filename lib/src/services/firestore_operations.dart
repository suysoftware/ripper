import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ripper/src/models/user.dart';

class FirestoreOperations {
  static Future<RipperUser> getRipperUser(String userUid) async {
    // ignore: prefer_typing_uninitialized_variables
    late var ripperUser;
    DocumentReference ripperUserRef =
        FirebaseFirestore.instance.collection('users').doc(userUid);

    await ripperUserRef
        .get()
        .then((docValue) => ripperUser = RipperUser.withInfo(
              docValue['user_uid'],
              docValue['user_name'],
              docValue['user_email'],
              docValue['user_password'],
              docValue['user_first_verify'],
              docValue['user_second_verify'],
              docValue['user_token'],
              docValue['user_photo'],
              docValue['user_phone'],
            ));

    return ripperUser;
  }

  static Future<List> getLeaderBoard() async {
    // ignore: prefer_typing_uninitialized_variables
    var ripperLeaderBoard = [];
    DocumentReference ripperLeaderBoardRef =
        FirebaseFirestore.instance.collection('settings').doc('leaderboard');

    // await ripperLeaderBoardRef.get().then((docValue) => ripperLeaderBoard =docValue);

    await ripperLeaderBoardRef.get().then((value) {
      for (var element in value['top_list']) {
        ripperLeaderBoard.add({
          'user_name': element['user_name'],
          'user_year': element['user_year'],
        });
      }
    });

    return ripperLeaderBoard;
  }
}
