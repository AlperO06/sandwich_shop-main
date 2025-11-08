class PricingRepository {
  static const double sixInchPrice = 7.0;
  static const double footlongPrice = 11.0;
  
  final int quantity;
  final bool isFootlong;

  const PricingRepository({
    required this.quantity,
    required this.isFootlong,
  });

  double calculateTotal() {
    final basePrice = isFootlong ? footlongPrice : sixInchPrice;
    return basePrice * quantity;
  }
}
