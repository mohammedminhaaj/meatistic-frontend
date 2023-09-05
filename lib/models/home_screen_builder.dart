class HomeScreenBuilder {
  HomeScreenBuilder({
    this.homeScreenUpdated = false,
    this.carouselImages = const [],
    this.allProducts = const [],
    this.categories = const [],
    this.nearbyVendors = const [],
    this.featuredProducts = const [],
    this.topSelling = const [],
    this.topRated = const [],
  });

  final bool homeScreenUpdated;
  final List<String> carouselImages;
  final List<dynamic> allProducts;
  final List<dynamic> categories;
  final List<dynamic> nearbyVendors;
  final List<dynamic> featuredProducts;
  final List<dynamic> topSelling;
  final List<dynamic> topRated;

  HomeScreenBuilder copyWith(
      {bool? homeScreenUpdated,
      List<String>? carouselImages,
      List<dynamic>? allProducts,
      List<dynamic>? categories,
      List<dynamic>? nearbyVendors,
      List<dynamic>? featuredProducts,
      List<dynamic>? topSelling,
      List<dynamic>? topRated}) {
    return HomeScreenBuilder(
        homeScreenUpdated: homeScreenUpdated ?? this.homeScreenUpdated,
        carouselImages: carouselImages ?? this.carouselImages,
        allProducts: allProducts ?? this.allProducts,
        categories: categories ?? this.categories,
        nearbyVendors: nearbyVendors ?? this.nearbyVendors,
        featuredProducts: featuredProducts ?? this.featuredProducts,
        topSelling: topSelling ?? this.topSelling,
        topRated: topRated ?? this.topRated);
  }
}
