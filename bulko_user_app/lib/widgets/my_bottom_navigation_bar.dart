// MyBottomNavigationBar
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:user/controllers/home_controller.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function(int)? onTap;

  MyBottomNavigationBar({this.onTap}) : super();

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState(onTap: onTap);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  Function(int)? onTap;
  HomeController homeController = Get.find();
  _MyBottomNavigationBarState({this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: homeController.tabIndex,
      onDestinationSelected: (value) {
        setState(() {
          if (value != 1) {
            homeController.changeTabIndex(value);
          }
          onTap!(value);
        });
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: "${AppLocalizations.of(context)!.txt_home}",
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          label: "${AppLocalizations.of(context)!.txt_search}",
        ),
        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          label: "${AppLocalizations.of(context)!.tle_order}",
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          label: "${AppLocalizations.of(context)!.txt_profile}",
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined), // Added icon for the cart
          label: "${AppLocalizations.of(context)!.txt_cart}",
        ),
      ],
    );
  }
}
