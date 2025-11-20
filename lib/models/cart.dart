import 'package:sandwich_shop/models/sandwich.dart';

class CartEntry {
  final Sandwich sandwich;
  final int quantity;

  CartEntry(this.sandwich, this.quantity);
}

class Cart {
  final List<CartEntry> _entries = [];

  // Add a sandwich to the cart. quantity defaults to 1.
  void add(Sandwich sandwich, {int quantity = 1}) {
    _entries.add(CartEntry(sandwich, quantity));
  }

  // Read-only view of entries (number of distinct adds)
  List<CartEntry> get entries => List.unmodifiable(_entries);

  // Total price for all entries (footlong = £7.00, six-inch = £5.00)
  double totalPrice() {
    double total = 0.0;
    for (final e in _entries) {
      double base = e.sandwich.isFootlong ? 7.0 : 5.0;
      total += base * e.quantity;
    }
    return total;
  }

  void clear() {
    _entries.clear();
  }
}
