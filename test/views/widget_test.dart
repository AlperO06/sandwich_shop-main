import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart'; // for BreadType / SandwichType used in OrderItemDisplay tests

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

      // Sandwich type dropdown exists
      expect(find.byType(DropdownMenu), findsWidgets);

      // Bread type dropdown exists
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

      final Finder sizeSwitchFinder = find.byType(Switch);
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

      // Open sandwich type dropdown
      await tester.tap(find.byType(DropdownMenu).first);
      await tester.pumpAndSettle();

      // Pick a different sandwich type by visible label (using one defined in model)
      // 'Tuna Melt' is defined in the model
      await tester.tap(find.text('Tuna Melt').last);
      await tester.pumpAndSettle();

      // The selected label should now be visible somewhere in the subtree
      expect(find.text('Tuna Melt'), findsWidgets);
    });

    testWidgets('select bread type from dropdown (no crash, selection visible)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Open bread type dropdown
      await tester.tap(find.byType(DropdownMenu).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('Add to Cart button is enabled when quantity > 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Ensure quantity > 0 initially
      expect(find.text('1'), findsWidgets);

      // Add to Cart button should be present and tappable
      final Finder addToCart = find.text('Add to Cart');
      expect(addToCart, findsOneWidget);

      await tester.tap(addToCart);
      await tester.pump();
      // no exception = success; assert button still present
      expect(addToCart, findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.textContaining('0 white untoasted footlong sandwich(es)'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.textContaining('3 white untoasted footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.textContaining('2 wheat untoasted six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        orderNote: 'Lots of lettuce',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.textContaining('1 wholemeal untoasted footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });

    testWidgets('shows toasted state correctly', (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
        isToasted: true,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.textContaining('2 white toasted six-inch sandwich(es): 🥪🥪'), findsOneWidget);
    });
  });
}