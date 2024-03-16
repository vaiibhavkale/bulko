import 'package:flutter/material.dart';

// Additional text themes
TextStyle boldCaptionStyle(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold);

TextStyle normalCaptionStyle(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
  // color: Colors.grey,
  fontSize: 14,
);

TextStyle normalHeadingStyle(BuildContext context) => Theme.of(context).textTheme.titleLarge!.copyWith(
  fontWeight: FontWeight.normal,
);

TextStyle textFieldHintStyle(BuildContext context) => Theme.of(context).textTheme.bodySmall!.copyWith(
  // color: Colors.grey[500],
  fontWeight: FontWeight.normal,
  fontSize: 15,
);

TextStyle textFieldInputStyle(BuildContext context, FontWeight? fontWeight) => Theme.of(context).textTheme.bodyLarge!.copyWith(
  // color: Colors.black,
  fontSize: 18,
  fontWeight: fontWeight ?? FontWeight.normal,
);

class ThemeUtils {
  static final ThemeData defaultAppThemeData = ThemeData(
      fontFamily: "Google-Sans",
      brightness: Brightness.light,
      colorSchemeSeed: Color(0xffFF0000),
      useMaterial3: true
  );
  static final ThemeData darkAppThemData = ThemeData(
    fontFamily: "Google-Sans",
    brightness: Brightness.light,
    colorSchemeSeed: Color(0xffFF0000),
    useMaterial3: true
  );
}
