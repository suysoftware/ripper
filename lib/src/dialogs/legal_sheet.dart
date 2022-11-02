import 'package:flutter/cupertino.dart';
import 'package:ripper/src/dialogs/delete_account_dialog.dart';
import 'package:ripper/src/screens/legals/terms_and_policy_dialog.dart';
import '../screens/legals/licences_screen.dart';


class LegalSheet extends StatelessWidget {
  const LegalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return TermsAndPrivacyDialog(
                      mdFileName: 'terms_and_conditions.md',
                      packageName: 'Terms And Conditions',
                    );
                  });
            },
            child: const Text('Terms & Conditions')),
        CupertinoActionSheetAction(
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return TermsAndPrivacyDialog(
                      mdFileName: 'privacy_policy.md',
                      packageName: 'Privacy Policy',
                    );
                  });
            },
            child: const Text('Privacy Policy')),
        CupertinoActionSheetAction(
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return const LicencesPage();
                  });
            },
            child: const Text('Licences')),
        CupertinoActionSheetAction(
          onPressed: () {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return const DeleteAccountDialog();
                });
          },
          child: const Text(
            'Delete My Account',
            style: TextStyle(color: CupertinoColors.systemRed),
          ),
        ),
      ],
    );
  }
}
