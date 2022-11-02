import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ripper/src/dialogs/error_dialog.dart';
import 'package:ripper/src/models/user.dart';
import 'package:ripper/src/services/firestore_operations.dart';

class FirebaseAuthService {
  // ignore: body_might_complete_normally_nullable
  static Future<User?> registerFirebase(String userName, String userEmail,
      String userPassword, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword)
          .then((kullanici) {});
      User? user = auth.currentUser!;
      await user
          .sendEmailVerification()
          .then((value) => null)
          .catchError((onError) => null);
      return user;
    } catch (e) {
      String errorMessage = e.toString().replaceRange(0, 40, '');
      ErrorDialogs.errorDialog(errorMessage, context);
      // ignore: avoid_print
      print(e);
    }
  }

  // ignore: body_might_complete_normally_nullable
  static Future<User?> loginFirebase(
      String userEmail, String userPassword, BuildContext? context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      )
          .then((kullanici) {
        //_isSigningIn = true;
      });
      User? user = FirebaseAuth.instance.currentUser;

      return user;
    } catch (e) {
      // ignore: avoid_print
      if (context != null) {
        ErrorDialogs.errorDialog("Email or Password is false", context);
      }
    }
  }

  // ignore: body_might_complete_normally_nullable
  static Future<RipperUser?> loggedCheck() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
//useri kaydet
      // ignore: prefer_typing_uninitialized_variables
      var ripperUser;

      try {
        await FirestoreOperations.getRipperUser(user.uid)
            .then((value) => ripperUser = value);
      } catch (e) {
        logoutFirebase();
      }

      return ripperUser;
    }
  }

  static Future<void> logoutFirebase() async {
    try {
      if (!kIsWeb) {
        //await firebaseAuth.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  static Future<void> deleteAccount(String userUid) async {
    var date = DateTime.now();
    await FirebaseFirestore.instance
        .collection('delete_account_requests')
        .doc(userUid)
        .set({
          'deleted_time':date,
          'user_uid':userUid
        });
  }
}
