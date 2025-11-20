import 'package:flutter_test/flutter_test.dart';

class Item { // Define the Item class for testing
  final String name;
  final double price;

  Item({required this.name, required this.price});
}

class Cart { // Define the Cart class for managing items
  final List<Item> items = [];

  void addItem(Item item) {
    items.add(item);
  }

  void removeItem(Item item) {
    items.remove(item);
  }

  double get totalPrice => items.fold(0, (sum, item) => sum + item.price);
}

void main() {
  test('Add item to cart', () {
    Cart cart = Cart(); // Ensure Cart is correctly referenced
    Item item = Item(name: 'Sandwich', price: 5.0);
    cart.addItem(item);
    expect(cart.items.length, 1);
    expect(cart.totalPrice, 5.0);
  });

  test('Remove item from cart', () {
    Cart cart = Cart(); // Ensure Cart is correctly referenced
    Item item = Item(name: 'Sandwich', price: 5.0);
    cart.addItem(item);
    cart.removeItem(item);
    expect(cart.items.length, 0);
    expect(cart.totalPrice, 0.0);
  });
}
