import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:user/models/categoryProductModel.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/widgets/products_menu.dart';

class DashboardTopSellingProductList extends StatelessWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final List<Product> topSellingProducts;

  const DashboardTopSellingProductList(
      {super.key,
      this.analytics,
      this.observer,
      required this.topSellingProducts});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocalizations.of(context)!.tle_popular_products}",
                style: textTheme.titleLarge,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ProductListScreen(
                        analytics: analytics,
                        observer: observer,
                        categoryName:
                            '${AppLocalizations.of(context)!.tle_popular_products}',
                      ));
                },
                child: Text(
                  "${AppLocalizations.of(context)!.btn_view_all} ",
                  style: textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ProductsMenu(
            analytics: analytics,
            observer: observer,
            categoryProductList: topSellingProducts,
          ),
        )
      ],
    );
  }
}
