import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:user/models/categoryListModel.dart';
import 'package:user/screens/all_categories_screen.dart';
import 'package:user/screens/sub_categories_screen.dart';
import 'package:user/widgets/select_category_card.dart';

class DashboardCategories extends StatefulWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final List<CategoryList> topCategoryList;

  DashboardCategories({super.key, this.analytics, this.observer, required this.topCategoryList});

  _DashboardCategoriesState createState() {
    return _DashboardCategoriesState(topCategoryList: this.topCategoryList);
  }
}

class _DashboardCategoriesState extends State<DashboardCategories> {
  int _selectedIndex = 0;
  final List<CategoryList> topCategoryList;

  _DashboardCategoriesState({required this.topCategoryList});

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
                "${AppLocalizations.of(context)!.tle_category}",
                style: textTheme.titleLarge,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AllCategoriesScreen(
                    analytics: widget.analytics,
                    observer: widget.observer,
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
        Container(
          height: 120,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topCategoryList.length,
              itemBuilder: (context, index) {
                return SelectCategoryCard(
                  key: UniqueKey(),
                  category: topCategoryList[index],
                  onPressed: () {
                    setState(() {
                     topCategoryList
                          .map((e) => e.isSelected = false)
                          .toList();
                      _selectedIndex = index;
                      if (_selectedIndex == index) {
                        topCategoryList[index]
                            .isSelected = true;
                      }
                    });
                    Get.to(() => SubCategoriesScreen(
                      analytics: widget.analytics,
                      observer: widget.observer,
                      screenHeading: topCategoryList[index].title,
                      categoryId: topCategoryList[index].catId,
                    ));
                  },
                  isSelected: topCategoryList[index].isSelected,
                );
              }),
        )
      ],
    );
  }
}
