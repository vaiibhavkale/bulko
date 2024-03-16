import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:user/controllers/cart_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/homeScreenDataModel.dart';
import 'package:user/screens/notification_screen.dart';
import 'package:user/screens/product_description_screen.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/screens/search_screen.dart';
import 'package:user/widgets/dashboard_widgets.dart';

class DashboardScreen extends BaseRoute {
  final Function()? onAppDrawerButtonPressed;

  DashboardScreen({
    super.analytics,
    super.observer,
    super.routeName = 'DashboardScreen',
    this.onAppDrawerButtonPressed
  });

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(onAppDrawerButtonPressed: onAppDrawerButtonPressed);
}

class _DashboardScreenState extends BaseRouteState {
  Function()? onAppDrawerButtonPressed;
  late Future<HomeScreenData> _homeScreenData;
  IconData lastTapped = Icons.notifications;
  AnimationController? menuAnimation;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  // _DashboardScreenState({this.onAppDrawerButtonPressed});
  _DashboardScreenState({this.onAppDrawerButtonPressed}) {
    _homeScreenData = _getHomeScreenData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: DashboardFloatingActionButton(
            analytics: widget.analytics,
            observer: widget.observer,
            callNumberStore: callNumberStore,
            inviteFriendShareMessage: br.inviteFriendShareMessage
        ),
        appBar: AppBar(
          leadingWidth: 46,
          leading: IconButton(
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            icon: Icon(Icons.dashboard_outlined),
            onPressed: onAppDrawerButtonPressed,
          ),
          title: DashboardLocationTitle(
              analytics: widget.analytics,
              observer: widget.observer,
              getCurrentPosition: getCurrentPosition
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await openBarcodeScanner(_scaffoldKey);
                },
                visualDensity: VisualDensity(horizontal: -4),
                icon: Icon(
                  MdiIcons.barcode,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
              visualDensity: VisualDensity(horizontal: -4),
              icon: Icon(Icons.search_outlined),
              onPressed: () => Get.to(() => SearchScreen(
                analytics: widget.analytics,
                observer: widget.observer,
              )),
            ),
            global.currentUser?.id != null
                ? IconButton(
                    visualDensity: VisualDensity(horizontal: -4),
                    icon: Icon(Icons.notifications_none),
                    onPressed: () => Get.to(() => NotificationScreen(
                      analytics: widget.analytics,
                      observer: widget.observer,
                    )),
                  ) : SizedBox()
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _onRefresh();
          },
          child: FutureBuilder<HomeScreenData>(
            future: _homeScreenData,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const DashboardLoadingView();
              } else if(snapshot.connectionState == ConnectionState.done) {
                if (global.nearStoreModel != null && global.nearStoreModel?.id != null && snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardAppNotice(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16,
                          ),
                          child: DashboardScreenHeading(),
                        ),
                        (snapshot.data?.banner.isNotEmpty ?? false) ?
                          DashboardBanner(
                              items: _bannerItems(snapshot.data!)
                          ) : SizedBox(),
                        (snapshot.data?.topCat.isNotEmpty ?? false) ?
                          DashboardCategories(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            topCategoryList: snapshot.data!.topCat,
                          ) : SizedBox(),
                        (snapshot.data?.dealproduct.isNotEmpty ?? false) ?
                            DashboardBundleProducts(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              title: "${AppLocalizations.of(context)!.tle_bundle_offers}",
                              categoryName: '${AppLocalizations.of(context)!.tle_bundle_offers} ${AppLocalizations.of(context)!.tle_products}',
                              dealProducts: snapshot.data!.dealproduct,
                              screenId: 1,
                            ) : SizedBox(),
                        (snapshot.data?.catProdList.isNotEmpty ?? false) ?
                          DashboardProductListByCategory(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            productListByCategory: snapshot.data!.catProdList,
                          ) : SizedBox.shrink(),
                        (snapshot.data?.whatsnewProductList.isNotEmpty ?? false) ?
                            DashboardBundleProducts(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              title: "${AppLocalizations.of(context)!.lbl_whats_new}",
                              categoryName: '${AppLocalizations.of(context)!.lbl_whats_new} ${AppLocalizations.of(context)!.tle_products}',
                              dealProducts: snapshot.data!.whatsnewProductList,
                              screenId: 3,
                            ) : SizedBox(),
                        (snapshot.data?.secondBanner.isNotEmpty ?? false) ?
                          DashboardBanner(
                              margin: EdgeInsets.only(top: 20),
                              items: _secondBannerItems(snapshot.data!)
                          ) : SizedBox(),
                        (snapshot.data?.spotLightProductList.isNotEmpty ?? false) ?
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title: "${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}",
                            categoryName: '${AppLocalizations.of(context)!.lbl_in_spotlight} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: snapshot.data!.spotLightProductList,
                            screenId: 4,
                          ) : SizedBox(),
                        (snapshot.data?.recentSellingProductList.isNotEmpty ?? false) ?
                          DashboardBundleProducts(
                            analytics: widget.analytics,
                            observer: widget.observer,
                            title: "${AppLocalizations.of(context)!.lbl_recent_selling} ${AppLocalizations.of(context)!.tle_products}",
                            categoryName: '${AppLocalizations.of(context)!.lbl_recent_selling} ${AppLocalizations.of(context)!.tle_products}',
                            dealProducts: snapshot.data!.recentSellingProductList,
                            screenId: 5,
                          ) : SizedBox(),
                        (snapshot.data?.topselling.isNotEmpty ?? false) ?
                            DashboardTopSellingProductList(
                              analytics: widget.analytics,
                              observer: widget.observer,
                              topSellingProducts: snapshot.data!.topselling,
                            ) : SizedBox(),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(global.locationMessage!),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(global.locationMessage!),
                    ),
                  );
                }
              } else {
                return Text("This shouldn't be seen ever");
              }
            },
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    menuAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _init();
  }

  List<Widget> _bannerItems(HomeScreenData homeScreenData) {
    List<Widget> list = [];
    for (int i = 0; i < homeScreenData.banner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductListScreen(
            analytics: widget.analytics,
            observer: widget.observer,
            categoryId: homeScreenData.banner[i].catId,
            screenId: 0,
            categoryName: homeScreenData.banner[i].title,
          ));
        },
        child: CachedNetworkImage(
          imageUrl:
          global.appInfo!.imageUrl! + homeScreenData.banner[i].bannerImage!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  Future<HomeScreenData> _getHomeScreenData() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        dynamic result = await apiHelper.getHomeScreenData();
        if (result != null) {
          if (result.status == "1") {
            return result.data;
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - dashboard_screen.dart - _getHomeScreenData():" +
          e.toString());
    }

    // Handle the case where data retrieval fails, return a default value or handle the error gracefully
    return HomeScreenData(); // You can replace this with an appropriate default value
  }


  _init() async {
    try {
      if (global.lat == null && global.lng == null) {
        await getCurrentPosition();
      }

      _homeScreenData = _getHomeScreenData();

      if (global.currentUser?.id != null) {
        cartController.getCartList();
      }
      setState(() {});
    } catch (e) {
      print("Exception - dashboard_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      await _init();
    } catch (e) {
      print("Exception - dashboard_screen.dart - _onRefresh():" + e.toString());
    }
  }

  List<Widget> _secondBannerItems(HomeScreenData homeScreenData) {
    List<Widget> list = [];
    for (int i = 0; i < homeScreenData.secondBanner.length; i++) {
      list.add(InkWell(
        onTap: () {
          Get.to(() => ProductDescriptionScreen(
            analytics: widget.analytics,
            observer: widget.observer,
            productId: homeScreenData.secondBanner[i].varientId,
            screenId: 0,
          ));
        },
        child: CachedNetworkImage(
          imageUrl: global.appInfo!.imageUrl! +
              homeScreenData.secondBanner[i].bannerImage!,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage('assets/images/icon.png'),
                  fit: BoxFit.cover),
            ),
          ),
        ),
      ));
    }
    return list;
  }

  void callNumberStore(store_number) async {
    await launchUrlString('tel:$store_number');
  }
}
