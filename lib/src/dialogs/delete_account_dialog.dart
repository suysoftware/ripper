import 'package:flutter/cupertino.dart';
import 'package:ripper/src/validations/login_validator.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog>
    with LoginValidationMixin {
  var formKey = GlobalKey<FormState>();
  var user = RipperUser();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: CupertinoAlertDialog(
          title: const Text('You are deleting your account'),
          content: const Text('contentsss'),
          actions: [
            emailFormFieldBuild(),
            passwordFormFieldBuild(),
            applyDeletedDialogActionBuild(),
            declineDeleteDialogActionBuild(),
          ],
        ));
  }

  Widget emailFormFieldBuild() {
    return CupertinoTextFormFieldRow(
      validator: validateEmail,
      onSaved: (String? value) {
        if (value != null) {
          user.userEmail = value;
        }
      },
      prefix: const Text(
        '    Email:',
        style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
      ),
      showCursor: true,
      textAlign: TextAlign.center,
      style: const TextStyle(fontFamily: 'Roboto', fontSize: 13),
    );
  }

  Widget passwordFormFieldBuild() {
    return CupertinoTextFormFieldRow(
      validator: validateEmail,
      onSaved: (String? value) {
        if (value != null) {
          user.userPassword = value;
        }
      },
      prefix: const Text(
        '    Password:',
        style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
      ),
      obscureText: true,
      showCursor: true,
      style: const TextStyle(fontFamily: 'Roboto', fontSize: 13),
      textAlign: TextAlign.center,
    );
  }

  Widget applyDeletedDialogActionBuild() {
    return CupertinoDialogAction(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          FirebaseAuthService.loginFirebase(
                  user.userEmail, user.userPassword, context)
              .then((value) {
            if (value != null) {
              FirebaseAuthService.deleteAccount(value.uid);
              showCupertinoDialog(
                  context: context,
                  builder: (context) => const CupertinoActivityIndicator(
                        animating: true,
                      ));
              Future.delayed(const Duration(milliseconds: 2000), () {
                FirebaseAuthService.logoutFirebase().whenComplete(() {
                  Navigator.pushReplacementNamed(context, '/LoggedOut');
                });
              });

              ///buraya logout olma ve geri gelme eklenecek
            } else {}
          });
          //
          // Login checker operation
        }
      },
      child: const Text(
        'Yes, Delete my account',
        style: TextStyle(color: CupertinoColors.systemRed),
      ),
    );
  }

  declineDeleteDialogActionBuild() {
    return CupertinoDialogAction(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'No',
      ),
    );
  }
}
