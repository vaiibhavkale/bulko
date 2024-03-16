import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/chat_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/product_request_screen.dart';

class DashboardFloatingActionButton extends StatefulWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final Function callNumberStore;
  final Function inviteFriendShareMessage;

  DashboardFloatingActionButton({super.key, required this.analytics, required this.observer, required this.callNumberStore, required this.inviteFriendShareMessage});

  @override
  _DashboardFloatingActionButtonState createState() => _DashboardFloatingActionButtonState();
}

class _DashboardFloatingActionButtonState extends State<DashboardFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final shouldShowFloatingButton = global.nearStoreModel != null &&
        global.nearStoreModel?.id != null &&
        global.currentUser != null &&
        global.currentUser?.id != null;

    if (shouldShowFloatingButton)
      return SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        spacing: 3,
        overlayOpacity: 0.8,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        direction: SpeedDialDirection.up,
        closeManually: false,
        elevation: 8.0,
        isOpenOnStart: false,
        animationDuration: const Duration(milliseconds: 200),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.share),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onTap: () {
                widget.inviteFriendShareMessage(callId: 0);
              }),
          SpeedDialChild(
              child: const Icon(Icons.call),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onTap: () {
                widget.callNumberStore(global.nearStoreModel!.phoneNumber);
              }),
          SpeedDialChild(
              child: Icon(MdiIcons.chatOutline),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onTap: () {
                if (global.currentUser?.id == null) {
                  Get.to(() => LoginScreen(
                      analytics: widget.analytics, observer: widget.observer));
                } else {
                  if (global.nearStoreModel != null) {
                    Get.to(() => ChatScreen(
                        analytics: widget.analytics, observer: widget.observer));
                  }
                }
              }),
          SpeedDialChild(
              child: Icon(MdiIcons.clipboardTextOutline),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              visible: true,
              onTap: () {
                if (global.currentUser!.id == null) {
                  Get.to(() => LoginScreen(
                      analytics: widget.analytics, observer: widget.observer));
                } else {
                  Get.to(() => ProductRequestScreen(
                      analytics: widget.analytics, observer: widget.observer));
                }
              }),
        ],
      );
    return SizedBox();
  }

}
