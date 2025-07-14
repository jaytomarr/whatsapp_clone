import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    scaffoldBackgroundColor: backgroundDark,
    extensions: [CustomThemeExtension.darkMode],
    appBarTheme: AppBarTheme(
      backgroundColor: greyBackground,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: greyDark,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: greyDark),
    ),
    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: greenDark, width: 2),
      ),
      unselectedLabelColor: greyDark,
      labelColor: greenDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenDark,
        foregroundColor: backgroundDark,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: greyBackground,
      modalBackgroundColor: greyBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: greyBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: greenDark,
      foregroundColor: Colors.white,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: greyDark,
      // tileColor: greyBackground,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(greyDark),
      trackColor: WidgetStatePropertyAll(Color(0xff344047)),
    ),
  );
}
