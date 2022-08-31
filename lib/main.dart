import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_tabbar/components/menu_card.dart';
import 'package:scrollable_tabbar/components/restaruant_categories.dart';
import 'package:scrollable_tabbar/components/restaurant_info.dart';
import 'package:scrollable_tabbar/models/menu.dart';

import 'components/resturant_app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scrollController = ScrollController();
  double restaurantInfoHeight = 200 + 170 - kToolbarHeight;
  int selectedCategoryIndex = 0;
  @override
  void initState() {
    createBreackPoint();
    scrollController.addListener(() {
      updateCategoryIndexOnScroll(scrollController.offset);
    });
    super.initState();
  }

  void scrollToCategory(int index) {
    if (selectedCategoryIndex != index) {
      int totalItems = 0;

      for (var i = 0; i < index; i++) {
        totalItems += demoCategoryMenus[i].items.length;
      }
      scrollController.animateTo(
        restaurantInfoHeight + (116 * totalItems) + (50 * index),
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        selectedCategoryIndex = index;
      });
    }
  }

  //scroll to selected category
  List<double> breakPoints = [];
  void createBreackPoint() {
    // 116 = 100 Menu Item height + 16 bottom padding for each item
    // 50 = 18 title font size 32 (16 vertical padding)
    double firstBreakPoint =
        restaurantInfoHeight + 50 + (116 * demoCategoryMenus[0].items.length);
    breakPoints.add(firstBreakPoint);
    for (var i = 1; i < demoCategoryMenus.length; i++) {
      double breackPoint =
          breakPoints.last + 50 + (116 * demoCategoryMenus[i].items.length);
      breakPoints.add(breackPoint);
    }
  }

  void updateCategoryIndexOnScroll(double offset) {
    for (var i = 0; i < demoCategoryMenus.length; i++) {
      if (i == 0) {
        if ((offset < breakPoints.first) & (selectedCategoryIndex != 0)) {
          setState(() {
            selectedCategoryIndex = 0;
          });
        }
      } else if ((breakPoints[i - 1] <= offset) & (offset < breakPoints[i])) {
        if (selectedCategoryIndex != i) {
          setState(() {
            selectedCategoryIndex = i;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          const RestaurantAppBar(),
          const SliverToBoxAdapter(
            child: RestaurantInfo(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: RestaurantCategories(
              onChanged: scrollToCategory,
              selectedIndex: selectedCategoryIndex,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, categoryIndex) {
                  List<Menu> items = demoCategoryMenus[categoryIndex].items;
                  return MenuCategoryItem(
                    title: demoCategoryMenus[categoryIndex].category,
                    items: List.generate(
                      items.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: MenuCard(
                          image: items[index].image,
                          title: items[index].title,
                          price: items[index].price,
                        ),
                      ),
                    ),
                  );
                },
                childCount: demoCategoryMenus.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
