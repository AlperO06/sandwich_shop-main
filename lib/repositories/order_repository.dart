class OrderRepository {
  int _quantity = 0;
  final int maxQuantity;

  OrderRepository({required this.maxQuantity});

  int get quantity => _quantity;

  bool get canIncrement => _quantity < maxQuantity;
  bool get canDecrement => _quantity > 0;

  void increment() {
    if (canIncrement) {
      _quantity++;
    }
  }

  void decrement() {
    if (canDecrement) {
      _quantity--;
    }
  }
}

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
