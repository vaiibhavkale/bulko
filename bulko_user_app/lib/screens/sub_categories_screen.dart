import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/subCategoryModel.dart';
import 'package:user/screens/productlist_screen.dart';
import 'package:user/widgets/select_category_card.dart';

class SubCategoriesScreen extends BaseRoute {
  @required
  final String? screenHeading;
  @required
  final int? categoryId;

  SubCategoriesScreen({
    super.analytics,
    super.observer,
    super.routeName = 'ProductListScreen',
    this.screenHeading,
    this.categoryId,
  });

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState(
      categoryId: categoryId, screenHeading: screenHeading);
}

// delegate class
class _DataSearch extends SearchDelegate<String> {
  final List<SubCategory> subCategoryList;

  _DataSearch(this.subCategoryList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results based on the search query
    final results = subCategoryList
        .where((subcategory) =>
            subcategory.title?.toLowerCase().contains(query.toLowerCase()) ??
            false)
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title ?? ''),
          onTap: () {
            // Implement action when a result is tapped
            close(context, results[index].title ?? '');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while the user types
    final suggestionList = query.isEmpty
        ? subCategoryList
        : subCategoryList
            .where((subcategory) =>
                subcategory.title
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].title ?? ''),
          onTap: () {
            // Implement action when a suggestion is tapped
            query = suggestionList[index].title ?? '';
            // Navigate to ProductListScreen with the selected subcategory's details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(
                  screenId: 0,
                  categoryName: suggestionList[index].title,
                  categoryId: suggestionList[index].catId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SubCategoriesScreenState extends BaseRouteState {
  int? categoryId;
  int _selectedIndex = 0;
  bool _isDataLoaded = false;
  int? screenId;
  String? screenHeading;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  List<SubCategory> _subCategoryList = [];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _SubCategoriesScreenState({this.categoryId, this.screenHeading});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenHeading!,
          style: textTheme.titleLarge,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.keyboard_arrow_left)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _DataSearch(
                    _subCategoryList), // Pass your subCategoryList here
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isDataLoaded
              ? _subCategoryList.length > 0
                  ? GridView.builder(
                      controller: _scrollController,
                      itemCount: _subCategoryList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: 1 / 1,
                      ),
                      itemBuilder: (context, index) => SelectCategoryCard(
                        key: UniqueKey(),
                        screenId: 1,
                        subCategory: _subCategoryList[index],
                        isSelected: _subCategoryList[index].isSelected,
                        borderRadius: 0,
                        onPressed: () {
                          setState(() {
                            _subCategoryList
                                .map((e) => e.isSelected = false)
                                .toList();
                            _selectedIndex = index;
                            if (_selectedIndex == index) {
                              _subCategoryList[index].isSelected = true;
                            }
                          });
                          Get.to(() => ProductListScreen(
                                analytics: widget.analytics,
                                observer: widget.observer,
                                screenId: 0,
                                categoryName: _subCategoryList[index].title,
                                categoryId: _subCategoryList[index].catId,
                              ));
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.txt_nothing_to_show}'),
                    )
              : _shimmer(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getSubCategoryList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          if (_subCategoryList.isEmpty) {
            page = 1;
          } else {
            page++;
          }
          await apiHelper.getSubCategory(page, categoryId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                List<SubCategory> _tList = result.data;
                if (_tList.isEmpty) {
                  _isRecordPending = false;
                }
                _subCategoryList.addAll(_tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _isRecordPending = false;
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _getSubCategoryList():" +
          e.toString());
    }
  }

  _init() async {
    try {
      await _getSubCategoryList();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getSubCategoryList();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _init():" + e.toString());
    }
  }

  _onRefresh() async {
    try {
      _isDataLoaded = false;
      _isRecordPending = true;
      setState(() {});
      await _init();
    } catch (e) {
      print("Exception - sub_categories_screen.dart - _onRefresh():" +
          e.toString());
    }
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.builder(
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) =>
                  SizedBox(height: 130, width: 90, child: Card()))),
    );
  }
}
