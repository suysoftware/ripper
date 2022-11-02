import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import '../constants/color_constants.dart';
import '../extensions/locale_keys.dart';

class AccountVerifyValidationMixin {
  Widget validateFirstLevel(bool? value) {
    if (value == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.settings_accountlevel1text.tr(),
            style: TextStyle(
              fontFamily: "Roboto",
              color: ColorConstants.fieldTextGrey,
              fontSize: 14.sp,
            ),
          ),
          const Icon(
            CupertinoIcons.checkmark_shield_fill,
            color: CupertinoColors.activeGreen,
          ),
        ],
      );
    } else {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.settings_accountlevel1text.tr(),
              style: TextStyle(
                fontFamily: "Roboto",
                color: ColorConstants.fieldTextGrey,
                fontSize: 14.sp,
              ),
            ),
            const Icon(
              CupertinoIcons.shield_slash,
              color: CupertinoColors.systemRed,
            ),
          ],
        ),
      );
    }
  }

  Widget validateSecondLevel(bool? value) {
    if (value == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.settings_accountlevel2text.tr(),
            style: TextStyle(
              fontFamily: "Roboto",
              color: ColorConstants.fieldTextGrey,
              fontSize: 14.sp,
            ),
          ),
          const Icon(
            CupertinoIcons.checkmark_shield_fill,
            color: CupertinoColors.activeGreen,
          ),
        ],
      );
    } else {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.settings_accountlevel2text.tr(),
              style: TextStyle(
                fontFamily: "Roboto",
                color: ColorConstants.fieldTextGrey,
                fontSize: 14.sp,
              ),
            ),
            const Icon(
              CupertinoIcons.shield_slash,
              color: CupertinoColors.systemRed,
            ),
          ],
        ),
      );
    }
  }
}
