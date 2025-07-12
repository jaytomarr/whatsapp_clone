import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

extension ExtendedTheme on BuildContext {
  CustomThemeExtension get theme {
    return Theme.of(this).extension<CustomThemeExtension>()!;
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? circleImageColor;
  final Color? greyColor;
  final Color? blueColor;
  final Color? langBtnBgColor;
  final Color? langBtnHighlightColor;
  final Color? authAppBarTextColor;
  final Color? photoIconBgColor;
  final Color? photoIconColor;
  final Color? profilePagebg;
  final Color? chatTextFieldBg;
  final Color? chatPageBgColor;
  final Color? chatPageDoodleColor;
  final Color? senderChatCardBg;
  final Color? receiverChatCardBg;
  final Color? yelloCardBgColor;
  final Color? yellowCardTextColor;

  CustomThemeExtension({
    this.circleImageColor,
    this.greyColor,
    this.blueColor,
    this.langBtnBgColor,
    this.langBtnHighlightColor,
    this.authAppBarTextColor,
    this.photoIconBgColor,
    this.photoIconColor,
    this.profilePagebg,
    this.chatTextFieldBg,
    this.chatPageBgColor,
    this.chatPageDoodleColor,
    this.senderChatCardBg,
    this.receiverChatCardBg,
    this.yelloCardBgColor,
    this.yellowCardTextColor,
  });

  static final lightMode = CustomThemeExtension(
    circleImageColor: Color(0xFF25D366),
    greyColor: greyLight,
    blueColor: blueLight,
    langBtnBgColor: Color(0xFFF7F8FA),
    langBtnHighlightColor: Color(0xFFE8E8ED),
    authAppBarTextColor: greenLight,
    photoIconBgColor: Color(0xfff0f2f3),
    photoIconColor: Color(0xff9daab3),
    profilePagebg: Color(0xfff7f8fa),
    chatTextFieldBg: Colors.white,
    chatPageBgColor: Color(0xffefe7de),
    chatPageDoodleColor: Colors.white70,
    senderChatCardBg: Color(0xffe7ffdb),
    receiverChatCardBg: Color(0xffffffff),
    yelloCardBgColor: Color(0xffffeecc),
    yellowCardTextColor: Color(0xff13191c),
  );
  static final darkMode = CustomThemeExtension(
    circleImageColor: greenDark,
    greyColor: greyDark,
    blueColor: blueDark,
    langBtnBgColor: Color(0xFF182229),
    langBtnHighlightColor: Color(0xFF09141A),
    authAppBarTextColor: Color(0xffe9edef),
    photoIconBgColor: Color(0xff283339),
    photoIconColor: Color(0xff61717b),
    profilePagebg: Color(0xff0b141a),
    chatTextFieldBg: greyBackground,
    chatPageBgColor: Color(0xff081419),
    chatPageDoodleColor: Color(0xff172428),
    senderChatCardBg: Color(0xff005c4b),
    receiverChatCardBg: greyBackground,
    yelloCardBgColor: Color(0xff222e35),
    yellowCardTextColor: Color(0xffffd279),
  );

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? circleImageColor,
    Color? greyColor,
    Color? blueColor,
    Color? langBtnBgColor,
    Color? langBtnHighlightColor,
    Color? authAppBarTextColor,
    Color? photoIconBgColor,
    Color? photoIconColor,
    Color? profilePageBg,
    Color? chatTextFieldBg,
    Color? chatPageBgColor,
    Color? chatPageDoodleColor,
    Color? senderChatCardBg,
    Color? receiverChatCardBg,
    Color? yelloCardBgColor,
    Color? yellowCardTextColor,
  }) {
    return CustomThemeExtension(
      circleImageColor: circleImageColor ?? this.circleImageColor,
      greyColor: greyColor ?? this.greyColor,
      blueColor: blueColor ?? this.blueColor,
      langBtnBgColor: langBtnBgColor ?? this.langBtnBgColor,
      langBtnHighlightColor: langBtnBgColor ?? this.langBtnBgColor,
      authAppBarTextColor: authAppBarTextColor ?? this.authAppBarTextColor,
      photoIconBgColor: photoIconBgColor ?? this.photoIconBgColor,
      photoIconColor: photoIconColor ?? this.photoIconColor,
      profilePagebg: profilePagebg ?? this.profilePagebg,
      chatTextFieldBg: chatTextFieldBg ?? this.chatTextFieldBg,
      chatPageBgColor: chatPageBgColor ?? this.chatPageBgColor,
      chatPageDoodleColor: chatPageDoodleColor ?? this.chatPageDoodleColor,
      senderChatCardBg: senderChatCardBg ?? this.senderChatCardBg,
      receiverChatCardBg: receiverChatCardBg ?? this.receiverChatCardBg,
      yelloCardBgColor: yelloCardBgColor ?? this.yelloCardBgColor,
      yellowCardTextColor: yellowCardTextColor ?? this.yellowCardTextColor,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    covariant ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      circleImageColor: Color.lerp(circleImageColor, other.circleImageColor, t),
      greyColor: Color.lerp(greyColor, other.greyColor, t),
      blueColor: Color.lerp(blueColor, other.blueColor, t),
      langBtnBgColor: Color.lerp(langBtnBgColor, other.langBtnBgColor, t),
      langBtnHighlightColor: Color.lerp(
        langBtnHighlightColor,
        other.langBtnHighlightColor,
        t,
      ),
      authAppBarTextColor: Color.lerp(
        authAppBarTextColor,
        other.authAppBarTextColor,
        t,
      ),
      photoIconBgColor: Color.lerp(photoIconBgColor, other.photoIconBgColor, t),
      photoIconColor: Color.lerp(photoIconColor, other.photoIconColor, t),
      profilePagebg: Color.lerp(profilePagebg, other.profilePagebg, t),
      chatTextFieldBg: Color.lerp(chatTextFieldBg, other.chatTextFieldBg, t),
      chatPageBgColor: Color.lerp(chatPageBgColor, other.chatPageBgColor, t),
      chatPageDoodleColor: Color.lerp(
        chatPageDoodleColor,
        other.chatPageDoodleColor,
        t,
      ),
      senderChatCardBg: Color.lerp(senderChatCardBg, other.senderChatCardBg, t),
      yellowCardTextColor: Color.lerp(
        yellowCardTextColor,
        other.yellowCardTextColor,
        t,
      ),
      yelloCardBgColor: Color.lerp(yelloCardBgColor, other.yelloCardBgColor, t),
      receiverChatCardBg: Color.lerp(
        receiverChatCardBg,
        other.receiverChatCardBg,
        t,
      ),
    );
  }
}
