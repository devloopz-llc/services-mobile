import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import 'account_tab_view.dart';
import 'bookings_tab_view.dart';
import 'home_tab_view.dart';
import 'messages_tab_view.dart';

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
            BookingsTabView(),
            MessagesTabView(),
            AccountTabView(),
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
