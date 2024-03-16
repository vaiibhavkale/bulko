import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/screens/app_drawer_wrapper_screen.dart';
import 'package:user/screens/cart_screen.dart';
import 'package:user/screens/login_screen.dart';
import 'package:user/screens/order_history_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/screens/user_profile_screen.dart';
import 'package:user/widgets/my_bottom_navigation_bar.dart';

class HomeScreen extends BaseRoute {
  final int? screenId;
  final Function? onAppDrawerButtonPressed;

  HomeScreen(
      {super.analytics,
      super.observer,
      super.routeName = 'HomeScreen',
      this.onAppDrawerButtonPressed,
      this.screenId});

  @override
  _HomeScreenState createState() => _HomeScreenState(
      onAppDrawerButtonPressed: onAppDrawerButtonPressed, screenId: screenId);
}

class _HomeScreenState extends BaseRouteState {
  int? screenId;
  Function? onAppDrawerButtonPressed;
  final CartController cartController = Get.put(CartController());
  final HomeController homeController = Get.put(HomeController());

  _HomeScreenState({this.onAppDrawerButtonPressed, this.screenId});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _homeScreenItems = [
      AppDrawerWrapperScreen(
        analytics: widget.analytics,
        observer: widget.observer,
      ),
      Container(),
      OrderHistoryScreen(
          analytics: widget.analytics, observer: widget.observer),
      UserProfileScreen(analytics: widget.analytics, observer: widget.observer),
      CartScreen(analytics: widget.analytics, observer: widget.observer),
    ];

    HomeController controller = Get.find<HomeController>();

    return WillPopScope(
      onWillPop: () async {
        exitAppDialogMenu();

        return false;
      },
      // return WillPopScope(
      //   onWillPop: () async {
      //     if (controller.tabIndex == 0) {
      //       // If on home screen, exit the app directly
      //       exitAppDialog();
      //       return false;
      //     } else {
      //       // If not on home screen, switch to home screen
      //       exitAppDialogMenu(); // Assuming you have a method to set tab index
      //       return false; // Do not exit the app
      //     }
      //   },
      child: Scaffold(
        body: GetBuilder<HomeController>(
          builder: (controller) {
            return IndexedStack(
              index: controller.tabIndex,
              children: _homeScreenItems,
            );
          },
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          onTap: (int value) async {
            await handleBottomNavigationBarTap(value);
          },
        ),
      ),
    );
  }

  Future<void> handleBottomNavigationBarTap(int value) async {
    print("Bottom Navigation Tapped: Index $value");

    if (value == 1) {
      return Get.to(() =>
          SearchScreen(analytics: widget.analytics, observer: widget.observer));
    } else if (value == 2 || value == 3 || value == 4 || value == 5) {
      if (global.currentUser?.id == null) {
        return Get.to(() => LoginScreen(
            analytics: widget.analytics, observer: widget.observer));
      }
      // If you want to navigate to CartScreen when clicking on the cart icon
      // Replace the line above with:
      // Get.to(() => CartScreen(analytics: widget.analytics, observer: widget.observer));
    }
    homeController.changeTabIndex(value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print('uID ${global.currentUser!.id}');
      if (screenId == 1) {
        Future.delayed(Duration.zero, () {
          homeController.changeTabIndex(3);
        });
      } else if (screenId == 2) {
        Future.delayed(Duration.zero, () {
          homeController.changeTabIndex(2);
        });
      } else {
        Future.delayed(Duration.zero, () {
          homeController.changeTabIndex(0);
        });
      }
      global.isNavigate = false;
    });
  }
}
