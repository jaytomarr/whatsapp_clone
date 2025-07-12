import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/common/helper/show_last_seen.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/chat/widgets/custom_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.profilePagebg,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverPersistentDelegate(user: user),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Text(user.username, style: TextStyle(fontSize: 24)),
                      SizedBox(height: 10),
                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                          fontSize: 20,
                          color: context.theme.greyColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'last seen ${lastSeenMessage(user.lastSeen)} ago',
                        style: TextStyle(color: context.theme.greyColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconWithText(icon: Icons.call, text: 'Call'),
                          iconWithText(icon: Icons.video_call, text: 'Video'),
                          iconWithText(
                            icon: Icons.search_rounded,
                            text: 'Search',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30),
                  title: Text("Hey there! I'm using WhatsappX"),
                  subtitle: Text(
                    '30th October',
                    style: TextStyle(color: context.theme.greyColor),
                  ),
                ),
                SizedBox(height: 20),
                CustomListTile(
                  title: 'Mute notifications',
                  leading: Icons.notifications,
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                CustomListTile(
                  title: 'Custom notifications',
                  leading: Icons.music_note,
                ),
                CustomListTile(
                  title: 'Media visibility',
                  leading: Icons.photo,
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
                SizedBox(height: 20),
                CustomListTile(
                  title: 'Encryption',
                  leading: Icons.lock,
                  subtitle:
                      'Messages and calls are end-to-end encrypted, Tap to verify.',
                ),
                CustomListTile(
                  title: 'Disappearing Messages',
                  leading: Icons.timer,
                  subtitle: 'Off',
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Create group with ${user.username}'),
                  leading: CustomIconButton(
                    onTap: () {},
                    icon: Icons.group_add,
                    backgroundColor: greenDark,
                    iconColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 25, right: 10),
                  title: Text(
                    'Block ${user.username}',
                    style: TextStyle(color: Color(0xfff15c6d)),
                  ),
                  leading: Icon(Icons.block, color: Color(0xfff15c6d)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 25, right: 10),
                  title: Text(
                    'Report ${user.username}',
                    style: TextStyle(color: Color(0xfff15c6d)),
                  ),
                  leading: Icon(Icons.thumb_down, color: Color(0xfff15c6d)),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  iconWithText({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: greenDark),
          SizedBox(height: 10),
          Text(text, style: TextStyle(color: greenDark)),
        ],
      ),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  final UserModel user;
  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 20;
  final double maxImageSize = 130;
  final double minImageSize = 40;

  SliverPersistentDelegate({required this.user});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / (maxHeaderHeight - 35);
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((size.width / 2) - 65 * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        color: Theme.of(context).appBarTheme.backgroundColor!.withValues(
          alpha: percent2 * 2 < 1 ? percent2 * 2 : 1,
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 15,
              left: currentImagePosition + 50,
              child: Text(
                user.username,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withValues(alpha: percent2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: BackButton(
                color: percent2 > 0.3
                    ? Colors.white.withValues(alpha: percent2)
                    : greyBackground,
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: CustomIconButton(
                onTap: () {},
                icon: Icons.more_vert,
                iconColor: percent2 > 0.3
                    ? Colors.white.withValues(alpha: percent2)
                    : greyBackground,
              ),
            ),
            Positioned(
              left: currentImagePosition,
              top: MediaQuery.of(context).viewPadding.top + 5,
              bottom: 0,
              child: Hero(
                tag: 'profile',
                child: Container(
                  width: currentImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
