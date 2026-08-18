import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/feedback/coming_soon_view.dart';
import '../controller/home_controller.dart';
import 'home_tab_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedTabIndex.value,
          children: const [
            HomeTabView(),
            ComingSoonView(icon: Icons.event_note_rounded, title: 'Bookings'),
            ComingSoonView(icon: Icons.chat_bubble_rounded, title: 'Messages'),
            ComingSoonView(icon: Icons.person_rounded, title: 'Account'),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedTabIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
