import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:user/controllers/home_controller.dart';
import 'package:user/controllers/order_controller.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/orderModel.dart';
import 'package:user/widgets/order_history_card.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryScreen extends BaseRoute {
  OrderHistoryScreen({super.analytics, super.observer, super.routeName = 'OrderHistoryScreen'});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends BaseRouteState {
  // private variable to switch tabs between orders
  OrderController orderController = Get.put(OrderController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final shouldNotShowData = global.nearStoreModel == null && global.nearStoreModel?.id == null;
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "${AppLocalizations.of(context)!.tle_order_history}",
            style: textTheme.titleLarge,
          ),
        ),
        body:
        shouldNotShowData
            ? Padding(
                padding: EdgeInsets.only(top: 150),
                child: Center(
                  child:
                      Text(AppLocalizations.of(context)!.txt_nothing_to_show),
                ),
              )
            : orderController.completedOrderList.length == 0 &&
                    (orderController.activeOrderList?.length ?? 0) == 0
                ? _emptyOrderListWidget()
                : DefaultTabController(
                    length: 2,
                    child: Column(children: [
                      TabBar(
                        tabs: [
                          Tab(
                              text:
                                  AppLocalizations.of(context)!.lbl_all_orders),
                          Tab(
                              text:
                                  AppLocalizations.of(context)!.lbl_past_orders)
                        ],
                        isScrollable: false,
                        onTap: (int index) {
                          orderController.page.value = index;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GetX<OrderController>(
                          builder: (controller) {
                            if (controller.isActiveOrderListLoaded.value ==
                                    true &&
                                controller.isCompletedOrderHistoryListLoaded ==
                                    true) {
                              return TabBarView(children: [
                                  OrderHistoryList(),
                                  OrderHistoryList()
                                ],
                                physics: const NeverScrollableScrollPhysics(),
                              );
                            } else {
                              return _shimmer();
                            }
                          },
                        ),
                      )
                    ]),
                  ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    orderController.page.value = 1;

    orderController.isMoreDataLoaded.value = false;
    orderController.isRecordPending.value = true;

    orderController.page1.value = 1;

    orderController.isMoreDataLoaded1.value = false;
    orderController.isRecordPending1.value = true;

    _getOrderHistory();
  }

  _getOrderHistory() async {
    await orderController.getActiveOrderList();
    await orderController.getCompletedOrderHistoryList();
    setState(() {});
  }

  Widget _emptyOrderListWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        color: Color(0xfffdfdfd),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Image.asset(
                "assets/images/no_order.png",
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 18,
              ),
              Center(
                child: FilledButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromWidth(350.0),
                    minimumSize: Size.fromHeight(55),
                    // foregroundColor: Color(0xffFF0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    homeController.navigateToHome();
                  }
                    //   Get.to(() => HomeScreen(
                    //     a: widget.analytics,
                    //     o: widget.observer,
                    // screenId: 0,
                    //   ))
                  ,
                  child: Text(
                    "${AppLocalizations.of(context)!.lbl_let_shop} ",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 230, width: MediaQuery.of(context).size.width, child: Card());
                    }),
              ],
            ),
          )),
    );
  }
}

final class OrderHistoryList extends StatelessWidget {
  late final List<Order> _orders;
  final OrderController orderController = Get.find();
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final scrollController = ScrollController();

  OrderHistoryList({this.analytics, this.observer, super.key}) {
    if (orderController.page.value == 1) {
      _orders = orderController.activeOrderList!;
    } else {
      _orders = orderController.completedOrderList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async { await _onRefresh(); },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _orders.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      OrderHistoryCard(
                        analytics: this.analytics,
                        observer: this.observer,
                        order: _orders[i],
                        index: i,
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                },
              ),
              orderController.isMoreDataLoaded.value == true ? SizedBox(child: CircularProgressIndicator()) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _onRefresh() async {
    try {
      orderController.getOrderHistory();
    } catch (e) {
      print("Exception - order_history_screen.dart - _onRefresh():" + e.toString());
    }
  }

}
