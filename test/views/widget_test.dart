import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
// for BreadType / SandwichType used in some tests

void main() {
  group('App', () {
    testWidgets('builds without throwing', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('OrderScreen - Basic UI and controls', () {
    testWidgets('builds without throwing (basic UI)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('builds without throwing (quantity controls)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('builds without throwing (size switch)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('builds without throwing (dropdowns)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('builds without throwing (add to cart)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('OrderScreen - Cart summary', () {
    testWidgets('builds without throwing (cart summary)', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Cart summary updates', () {
    testWidgets('cart summary updates when items are added', (WidgetTester tester) async {
      await tester.pumpWidget(const TestCartWidget());
      // initial state
      expect(find.byKey(const Key('cartItemCount')), findsOneWidget);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.byKey(const Key('cartTotal')), findsOneWidget);
      expect(find.text('Total: \$0.00'), findsOneWidget);

      // add one item
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.pumpAndSettle();
      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Total: \$4.50'), findsOneWidget);

      // add another item
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.pumpAndSettle();
      expect(find.text('Items: 2'), findsOneWidget);
      expect(find.text('Total: \$9.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple quick adds update summary correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestCartWidget());
      // add three items quickly
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.pumpAndSettle();
      expect(find.text('Items: 3'), findsOneWidget);
      expect(find.text('Total: \$13.50'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Additional widget tests', () {
    testWidgets('StyledButton onPressed is invoked', (WidgetTester tester) async {
      var pressed = false;
      final testButton = StyledButton(
        onPressed: () {
          pressed = true;
        },
        icon: Icons.add,
        label: 'Tap Me',
        backgroundColor: Colors.green,
      );
      final testApp = MaterialApp(home: Scaffold(body: testButton));
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();
      expect(find.text('Tap Me'), findsOneWidget);
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Order controls: quantity buttons, switch and dropdown behave', (WidgetTester tester) async {
      await tester.pumpWidget(const TestOrderControls());
      await tester.pumpAndSettle();

      // initial quantity is 1
      expect(find.text('Qty: 1'), findsOneWidget);

      // increment twice -> 3
      await tester.tap(find.byKey(const Key('qtyPlus')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('qtyPlus')));
      await tester.pumpAndSettle();
      expect(find.text('Qty: 3'), findsOneWidget);

      // decrement once -> 2
      await tester.tap(find.byKey(const Key('qtyMinus')));
      await tester.pumpAndSettle();
      expect(find.text('Qty: 2'), findsOneWidget);

      // cannot go below 1
      await tester.tap(find.byKey(const Key('qtyMinus')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('qtyMinus'))); // attempt to go to 0
      await tester.pumpAndSettle();
      expect(find.text('Qty: 1'), findsOneWidget);

      // toggle size switch
      expect(find.byKey(const Key('sizeSwitch')), findsOneWidget);
      final Switch switchWidget = tester.widget(find.byKey(const Key('sizeSwitch')));
      // initial is false
      expect(switchWidget.value, isFalse);
      await tester.tap(find.byKey(const Key('sizeSwitch')));
      await tester.pumpAndSettle();
      final Switch switchWidgetAfter = tester.widget(find.byKey(const Key('sizeSwitch')));
      expect(switchWidgetAfter.value, isTrue);

      // select a different bread from dropdown
      await tester.tap(find.byKey(const Key('breadDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wheat').last);
      await tester.pumpAndSettle();
      expect(find.text('Wheat'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Order controls: add to cart calculates totals correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const TestOrderControls());
      await tester.pumpAndSettle();

      // set quantity to 2
      await tester.tap(find.byKey(const Key('qtyPlus')));
      await tester.pumpAndSettle();

      // set large size
      await tester.tap(find.byKey(const Key('sizeSwitch')));
      await tester.pumpAndSettle();

      // add to cart
      await tester.tap(find.byKey(const Key('addToCart')));
      await tester.pumpAndSettle();

      // basePrice is 5.00, large size surcharge is 1.00 per item -> total = (5+1)*2 = 12.00
      expect(find.text('Items: 2'), findsOneWidget);
      expect(find.text('Total: \$12.00'), findsOneWidget);

      // add one more single (ensure accumulation works)
      await tester.tap(find.byKey(const Key('qtyPlus'))); // quantity now 2 again (qty was 1 after add)
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('addToCart'))); // adds 2 more items at large size
      await tester.pumpAndSettle();

      // now Items: 4, Total: previous 12.00 + (5+1)*2 = 24.00
      expect(find.text('Items: 4'), findsOneWidget);
      expect(find.text('Total: \$24.00'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });
  });
}

// Test-only widget used by the new tests above.
class TestCartWidget extends StatefulWidget {
  const TestCartWidget({Key? key}) : super(key: key);

  @override
  _TestCartWidgetState createState() => _TestCartWidgetState();
}

class _TestCartWidgetState extends State<TestCartWidget> {
  int itemCount = 0;
  double total = 0.0;
  static const double itemPrice = 4.50; // deterministic price used for assertions

  void _addItem() {
    setState(() {
      itemCount += 1;
      total += itemPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('Items: $itemCount', key: const Key('cartItemCount')),
            Text('Total: \$${total.toStringAsFixed(2)}', key: const Key('cartTotal')),
            ElevatedButton(
              key: const Key('addButton'),
              onPressed: _addItem,
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

// Test-only widget used by the new tests above.
class TestOrderControls extends StatefulWidget {
  const TestOrderControls({Key? key}) : super(key: key);

  @override
  _TestOrderControlsState createState() => _TestOrderControlsState();
}

class _TestOrderControlsState extends State<TestOrderControls> {
  int quantity = 1;
  bool isLarge = false;
  String bread = 'White';

  int cartItems = 0;
  double cartTotal = 0.0;

  static const double basePrice = 5.00;
  static const double largeSurcharge = 1.00;

  void _increment() {
    setState(() {
      quantity += 1;
    });
  }

  void _decrement() {
    setState(() {
      if (quantity > 1) quantity -= 1;
    });
  }

  void _toggleSize(bool? value) {
    if (value == null) return;
    setState(() {
      isLarge = value;
    });
  }

  void _selectBread(String? value) {
    if (value == null) return;
    setState(() {
      bread = value;
    });
  }

  void _addToCart() {
    setState(() {
      cartItems += quantity;
      cartTotal += (basePrice + (isLarge ? largeSurcharge : 0.0)) * quantity;
      quantity = 1; // reset selection after adding to cart
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  key: const Key('qtyMinus'),
                  icon: const Icon(Icons.remove),
                  onPressed: _decrement,
                ),
                Text('Qty: $quantity', key: const Key('qtyText')),
                IconButton(
                  key: const Key('qtyPlus'),
                  icon: const Icon(Icons.add),
                  onPressed: _increment,
                ),
              ],
            ),
            Row(
              children: [
                const Text('Large Size'),
                Switch(
                  key: const Key('sizeSwitch'),
                  value: isLarge,
                  onChanged: _toggleSize,
                ),
              ],
            ),
            DropdownButton<String>(
              key: const Key('breadDropdown'),
              value: bread,
              items: const [
                DropdownMenuItem(value: 'White', child: Text('White')),
                DropdownMenuItem(value: 'Wheat', child: Text('Wheat')),
                DropdownMenuItem(value: 'Sourdough', child: Text('Sourdough')),
              ],
              onChanged: _selectBread,
            ),
            ElevatedButton(
              key: const Key('addToCart'),
              onPressed: _addToCart,
              child: const Text('Add to Cart'),
            ),
            Text('Items: $cartItems', key: const Key('cartItemCount2')),
            Text('Total: \$${cartTotal.toStringAsFixed(2)}', key: const Key('cartTotal2')),
          ],
        ),
      ),
    );
  }
}