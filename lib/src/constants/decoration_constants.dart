import 'package:flutter/cupertino.dart';
import 'color_constants.dart';

class DecorationConstants {
  static BoxDecoration fieldBoxDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      color: ColorConstants.fieldGrey,
      border: Border.all(
        color: ColorConstants.fieldBoxGreen,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(15.0)));
}
