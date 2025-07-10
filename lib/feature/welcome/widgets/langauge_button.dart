import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  showBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 30,
                  decoration: BoxDecoration(
                    color: context.theme.greyColor!.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 20),
                    CustomIconButton(
                      onTap: () => Navigator.pop(context),
                      icon: Icons.close_outlined,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'App Language',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                //
                Divider(
                  color: context.theme.greyColor!.withValues(alpha: 0.3),
                  thickness: 0.5,
                ),
                RadioListTile(
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                  activeColor: greenDark,
                  title: Text('English'),
                  subtitle: Text(
                    "Phone's Language",
                    style: TextStyle(color: context.theme.greyColor),
                  ),
                ),
                RadioListTile(
                  value: true,
                  groupValue: false,
                  onChanged: (value) {},
                  activeColor: greenDark,
                  title: Text('हिन्दी'),
                  subtitle: Text(
                    'Hindi',
                    style: TextStyle(color: context.theme.greyColor),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: context.theme.langBtnBgColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => showBottomSheet(context),
          borderRadius: BorderRadius.circular(20),
          splashFactory: NoSplash.splashFactory,
          highlightColor: context.theme.langBtnHighlightColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: greenDark),
                SizedBox(width: 8),
                Text('English', style: TextStyle(color: greenDark)),
                SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_down_rounded, color: greenDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
