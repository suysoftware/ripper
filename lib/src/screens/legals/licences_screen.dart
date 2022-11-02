import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../../constants/color_constants.dart';
import '../../dialogs/licences_dialog.dart';

class LicencesPage extends StatefulWidget {
  const LicencesPage({Key? key}) : super(key: key);

  @override
  State<LicencesPage> createState() => _LicencesPageState();
}

class _LicencesPageState extends State<LicencesPage> {
  var licencesButtonList = <LicencesButton>[];

  var licencesList = [
    'CupertinoIcons',
    'EasyLocalization',
    'Sizer',
    'AutoSizeText',
    'FlutterBloc',
    'Uuid',
    'FlutterMarkdown',
    'FirebaseCore',
    'FirebaseAuth',
    'FirebaseDatabase',
    'FirebaseStorage',
    'CloudFirestore',
    'GoogleFonts',
  ];

  @override
  void initState() {
    super.initState();

    for (var item in licencesList) {
      var licencesButtonItem = LicencesButton(settingsItemText: item);

      licencesButtonList.add(licencesButtonItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.sweetGrey,
        navigationBar: CupertinoNavigationBar(
          padding: EdgeInsetsDirectional.only(bottom: 2.h),
          automaticallyImplyLeading: true,
          previousPageTitle: 'Settings',
        ),
        child: ListView.builder(
            itemCount: licencesButtonList.length,
            itemBuilder: (context, indeksNumarasi) =>
                licencesButtonList[indeksNumarasi]
            /*   licencesButtonGetter(
                Text("Cupertino Icons", style: settingTextStyle), () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return PolicyDialog(
                    mdFileName: 'privacy_policy.md',
                  );
                },
              );
            }),
               licencesButtonGetter(
                Text("Easy Localization", style: settingTextStyle), () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return PolicyDialog(
                    mdFileName: 'privacy_policy.md',
                  );
                },
              );
            }),

            licencesButtonGetter(Text("Provider", style: settingTextStyle), () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return PolicyDialog(
                    mdFileName: 'privacy_policy.md',
                  );
                },
              );
            }),
  */

            ));
  }
}

class LicencesButton extends StatelessWidget {
  const LicencesButton({Key? key, required this.settingsItemText})
      : super(key: key);
  final String settingsItemText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.whiteColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 1.sp,
                spreadRadius: 0.2.sp,
                offset: const Offset(0.0, 0.0),
                color: ColorConstants.blackColor.withOpacity(0.2))
          ],
          border: Border.all(width: 0.01, color: ColorConstants.blackColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.1.h),
        child: CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(settingsItemText),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: const Icon(
                  CupertinoIcons.forward,
                  color: CupertinoColors.systemGrey2,
                ),
              ),
            ],
          ),
          onPressed: () => showCupertinoDialog(
            context: context,
            builder: (context) {
              return LicencesDialog(
                mdFileName: '$settingsItemText.md',
                packageName: settingsItemText,
              );
            },
          ),
        ),
      ),
    );
  }
}
