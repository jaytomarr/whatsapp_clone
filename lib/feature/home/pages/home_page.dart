import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/home/pages/calls_home_page.dart';
import 'package:whatsapp_clone/feature/home/pages/chats_home_page.dart';
import 'package:whatsapp_clone/feature/home/pages/status_home_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Timer timer;
  updateUserPresence() {
    ref.read(authControllerProvider).updateUserPresence();
  }

  @override
  void initState() {
    updateUserPresence();
    timer = Timer.periodic(Duration(minutes: 1), (timer) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WhatsappX', style: TextStyle(letterSpacing: 1)),
          elevation: 1,
          actions: [
            CustomIconButton(onTap: () {}, icon: Icons.search_rounded),
            CustomIconButton(onTap: () {}, icon: Icons.more_vert),
          ],
          bottom: TabBar(
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [ChatsHomePage(), StatusHomePage(), CallsHomePage()],
        ),
      ),
    );
  }
}
