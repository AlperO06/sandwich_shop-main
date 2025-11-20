import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart'; // for BreadType / SandwichType used in some tests

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Basic UI and controls', () {
    testWidgets('initial UI elements are present', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Image placeholder exists
      expect(find.byType(Image), findsWidgets);

      // Dropdown menus exist (raw type)
      expect(find.byType(DropdownMenu), findsWidgets);

      // Size switch exists
      expect(find.byType(Switch), findsOneWidget);

      // Quantity controls exist (IconButton + and -)
      expect(find.widgetWithIcon(IconButton, Icons.add), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.remove), findsOneWidget);

      // Add to Cart button exists
      expect(find.text('Add to Cart'), findsOneWidget);

      // Initial quantity is 1 per current implementation
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('increments and decrements quantity', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final Finder addBtn = find.widgetWithIcon(IconButton, Icons.add);
      final Finder removeBtn = find.widgetWithIcon(IconButton, Icons.remove);

      // initial 1
      expect(find.text('1'), findsWidgets);

      // increment -> 2
      await tester.tap(addBtn);
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // decrement -> 1
      await tester.tap(removeBtn);
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // decrement -> 0
      await tester.tap(removeBtn);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      // try to go below 0 -> stays 0
      await tester.tap(removeBtn);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('size switch toggles value', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final Finder sizeSwitchFinder = find.byKey(const Key('size_switch'));
      expect(sizeSwitchFinder, findsOneWidget);

      Switch sw = tester.widget(sizeSwitchFinder);
      final bool initial = sw.value;

      await tester.tap(sizeSwitchFinder);
      await tester.pump();

      sw = tester.widget(sizeSwitchFinder);
      expect(sw.value, isNot(initial));
    });

    testWidgets('select sandwich type from dropdown (no crash, selection visible)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open sandwich type dropdown (first DropdownMenu)
      await tester.tap(find.byType(DropdownMenu).first);
      await tester.pumpAndSettle();

      // Pick 'Tuna Melt' by visible label (one of model's names)
      await tester.tap(find.text('Tuna Melt').last);
      await tester.pumpAndSettle();

      expect(find.text('Tuna Melt'), findsWidgets);
    });

    testWidgets('select bread type from dropdown (no crash, selection visible)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open bread type dropdown (last DropdownMenu)
      await tester.tap(find.byType(DropdownMenu).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('Add to Cart shows persistent confirmation', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final Finder addToCart = find.widgetWithText(ElevatedButton, 'Add to Cart');
      expect(addToCart, findsOneWidget);

      await tester.tap(addToCart);
      await tester.pumpAndSettle();

      // persistent confirmation text should appear
      expect(find.byKey(const Key('last_confirmation')), findsOneWidget);
      expect(find.textContaining('Added 1 footlong'), findsOneWidget);
    });
  });

  group('OrderScreen - Cart summary', () {
    testWidgets('cart summary updates when items are added', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // initial cart should be empty (Cart model shows 0 entries)
      expect(find.byKey(const Key('cart_item_count')), findsOneWidget);
      expect(find.textContaining('Cart: 0'), findsOneWidget);
      expect(find.byKey(const Key('cart_total_price')), findsOneWidget);
      expect(find.textContaining('Total: £0.00'), findsOneWidget);

      // increase quantity (tap Add) so we add 1 item (initially 1, tap Add to make 2, but to ensure single item we reset: better to press AddQty once then tap Add to Cart)
      // For safety, we'll tap the decrease button if quantity >1, then add as needed.
      // Here assume initial quantity is 1; tap Add to increment to 2 then decrease to 1 is optional - we will use current quantity 1 directly.
      // Tap Add to Cart
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // cart should now show 1 item with price for a footlong (£7.00)
      expect(find.textContaining('Cart: 1 items'), findsOneWidget);
      expect(find.textContaining('Total: £7.00'), findsOneWidget);
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
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}