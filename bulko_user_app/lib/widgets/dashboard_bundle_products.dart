import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:user/models/categoryProductModel.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/widgets/bundle_offers_menu.dart';

class DashboardBundleProducts extends StatelessWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final String title;
  final String categoryName;
  final List<Product> dealProducts;
  final int? screenId;

  DashboardBundleProducts({
    super.key,
    this.analytics,
    this.observer,
    required this.title,
    required this.categoryName,
    required this.dealProducts,
    this.screenId
  });

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
                title,
                style: textTheme.titleLarge,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => ProductListScreen(
                    analytics: analytics,
                    observer: observer,
                    screenId: screenId,
                    categoryName: categoryName,
                  ));
                },
                child: Text(
                  "${AppLocalizations.of(context)!.btn_view_all} ",
                  style: textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        BundleOffersMenu(
          analytics: analytics,
          observer: observer,
          categoryProductList: dealProducts,
        ),
      ],
    );
  }
}
