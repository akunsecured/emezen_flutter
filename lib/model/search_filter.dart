class SearchFilter {
  String? name;
  late List<int> categories;
  double? priceFrom;
  double? priceTo;

  SearchFilter(
      {this.name, List<int>? categories, this.priceFrom, this.priceTo}) {
    this.categories = (categories ?? []);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'categories': categories.join(','),
        'price_from': priceFrom,
        'price_to': priceTo
      };
}
