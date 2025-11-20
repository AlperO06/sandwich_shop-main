class Item { // Define the Item class if not already defined
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class Cart {
  final int quantity;
  final bool isFootlong;

  Cart({
    required this.quantity,
    required this.isFootlong,
  });

  double calculatePrice() {
    double basePrice = isFootlong ? 7.0 : 5.0;
    return basePrice * quantity;
  }
}
