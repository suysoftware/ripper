import 'package:flutter/cupertino.dart';

class ErrorDialogs {
  static Future<dynamic> errorDialog(
      String errorText, BuildContext context) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              actions: [
                CupertinoButton(
                    child: const Text("OKAY"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              content: Text(errorText),
            ));
  }


}
