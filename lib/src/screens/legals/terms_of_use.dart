import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:ripper/src/screens/legals/policy_dialog.dart';
import 'package:sizer/sizer.dart';
import '../../constants/color_constants.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our\n ",
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: CupertinoColors.systemGrey,
              fontFamily: "CoderStyle",
              fontSize: 10.sp),
          children: [
            TextSpan(
              text: "terms and conditions",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.blackColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      });
                },
            ),
             const TextSpan(text:" and  "),
            TextSpan(
              text: "Privacy Policy! ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.blackColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'privacy_policy.md',
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
