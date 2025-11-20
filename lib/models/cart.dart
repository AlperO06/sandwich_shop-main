class Item { // Define the Item class if not already defined
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class Cart {
  List<Item> items = []; // Assuming Item is a class representing an item in the cart
  double totalPrice = 0.0;

  void addItem(Item item) {
    items.add(item);
    calculateTotalPrice();
  }

  void removeItem(Item item) {
    items.remove(item);
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    // Assuming PricingRepository is not used, calculate total manually
    totalPrice = items.fold(0, (sum, item) => sum + item.price);
  }
}
