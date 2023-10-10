class SortMenuItem {
  final String name;
  final String filterName;

  SortMenuItem({required this.name, required this.filterName});
}

final List<SortMenuItem> sortMenuList = [
  SortMenuItem(name: "Price: Low", filterName: "low_price"),
  SortMenuItem(name: "Price: High", filterName: "high_price"),
  SortMenuItem(name: "Max Discount", filterName: "discount"),
  SortMenuItem(name: "Newest", filterName: "new"),
  SortMenuItem(name: "A-Z", filterName: "az"),
];

final List<SortMenuItem> vendorSortMenuList = [
  SortMenuItem(name: "Rating: High", filterName: "rating_high"),
  SortMenuItem(name: "Rating: Low", filterName: "rating_low"),
  SortMenuItem(name: "Distance: Far", filterName: "distance_far"),
  SortMenuItem(name: "Distance: Near", filterName: "distance_near"),
  SortMenuItem(name: "A-Z", filterName: "az")
];
