import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/helper/show_alert_dilaog.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_elevated_button.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/auth/pages/image_picker_page.dart';
import 'package:whatsapp_clone/feature/auth/widgets/custom_text_field.dart';
import 'package:whatsapp_clone/feature/welcome/widgets/short_h_bar.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String? profileImageUrl;
  const UserInfoPage({super.key, this.profileImageUrl});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  File? imageCamera;
  Uint8List? imageGallery;

  late TextEditingController usernameController;

  saveUserDataToFirebase() {
    String username = usernameController.text;
    if (username.isEmpty) {
      return showAlertDilaog(
        context: context,
        message: 'Please provide a username',
      );
    } else if (username.length < 3 || username.length > 20) {
      return showAlertDilaog(
        context: context,
        message: 'A username length should be between 3-20',
      );
    }
    ref
        .read(authControllerProvider)
        .saveUserInfoToFirestore(
          context: context,
          username: username,
          profileImage:
              imageCamera ?? imageGallery ?? widget.profileImageUrl ?? '',
          mounted: mounted,
        );
  }

  pickImageFromCamera() async {
    Navigator.of(context).pop();
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        imageCamera = File(image!.path);
        imageGallery = null;
      });
    } catch (e) {
      showAlertDilaog(context: context, message: e.toString());
    }
  }

  imagePickerTypeBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShortHBar(),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'Profile photo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                CustomIconButton(
                  onTap: () => Navigator.pop(context),
                  icon: Icons.close,
                ),
                SizedBox(width: 15),
              ],
            ),
            Divider(color: context.theme.greyColor!.withValues(alpha: 0.3)),
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 20),
                imagePickerIcon(
                  onTap: pickImageFromCamera(),
                  icon: Icons.camera_alt_rounded,
                  text: 'Camera',
                ),
                SizedBox(width: 15),
                imagePickerIcon(
                  onTap: () async {
                    Navigator.pop(context);
                    final image = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePickerPage(),
                      ),
                    );
                    if (image == null) return;
                    setState(() {
                      imageGallery = image;
                      imageCamera = null;
                    });
                  },
                  icon: Icons.photo_outlined,
                  text: 'Gallery',
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        );
      },
    );
  }

  imagePickerIcon({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
  }) {
    return Column(
      children: [
        CustomIconButton(
          onTap: onTap,
          icon: icon,
          iconColor: greenDark,
          minWidth: 50,
          border: Border.all(
            color: context.theme.greyColor!.withValues(alpha: 0.2),
          ),
        ),
        SizedBox(height: 5),
        Text(text, style: TextStyle(color: context.theme.greyColor)),
      ],
    );
  }

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Profile info',
          style: TextStyle(color: context.theme.authAppBarTextColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Please provide your name and an optional profile photo',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.theme.greyColor),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: imagePickerTypeBottomSheet,
              child: Container(
                padding: EdgeInsets.all(26),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.photoIconBgColor,
                  border: Border.all(
                    color:
                        imageCamera == null &&
                            imageGallery == null &&
                            widget.profileImageUrl == null
                        ? Colors.transparent
                        : context.theme.greyColor!.withValues(alpha: 0.4),
                  ),
                  image:
                      imageCamera != null ||
                          imageGallery != null ||
                          widget.profileImageUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: imageGallery != null
                              ? MemoryImage(imageGallery!) as ImageProvider
                              : widget.profileImageUrl != null
                              ? NetworkImage(widget.profileImageUrl!)
                              : FileImage(imageCamera!) as ImageProvider,
                        )
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3, right: 3),
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    size: 48,
                    color:
                        imageCamera == null &&
                            imageGallery == null &&
                            widget.profileImageUrl == null
                        ? context.theme.photoIconColor
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: CustomTextField(
                    controller: usernameController,
                    hintText: 'Type your name here',
                    textAlign: TextAlign.left,
                    autoFocus: true,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.emoji_emotions_outlined,
                  color: context.theme.photoIconColor,
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: saveUserDataToFirebase,
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }
}
