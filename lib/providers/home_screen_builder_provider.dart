import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/home_screen_builder.dart';

class HomeScreenBuilderNotifier extends StateNotifier<HomeScreenBuilder> {
  HomeScreenBuilderNotifier() : super(HomeScreenBuilder());

  void setHomeScreenUpdated(bool homeScreenUpdated) {
    state = state.copyWith(homeScreenUpdated: homeScreenUpdated);
  }

  void updateHomeScreen(
      bool homeScreenUpdated,
      List<String> carouselImages,
      List<dynamic> allProducts,
      List<dynamic> categories,
      List<dynamic> nearbyVendors,
      List<dynamic> featuredProducts,
      List<dynamic> topSelling,
      List<dynamic> topRated) {
    state = state.copyWith(
        homeScreenUpdated: homeScreenUpdated,
        carouselImages: carouselImages,
        allProducts: allProducts,
        categories: categories,
        nearbyVendors: nearbyVendors,
        featuredProducts: featuredProducts,
        topSelling: topSelling,
        topRated: topRated);
  }
}

final homeScreenBuilderProvider =
    StateNotifierProvider<HomeScreenBuilderNotifier, HomeScreenBuilder>(
        (ref) => HomeScreenBuilderNotifier());
