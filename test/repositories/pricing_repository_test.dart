import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('calculates correct price for six-inch sandwiches', () {
      final repo = PricingRepository(quantity: 2, isFootlong: false);
      expect(repo.calculateTotal(), 14.0); // 2 * £7
    });

    test('calculates correct price for footlong sandwiches', () {
      final repo = PricingRepository(quantity: 3, isFootlong: true);
      expect(repo.calculateTotal(), 33.0); // 3 * £11
    });

    test('returns zero when quantity is zero', () {
      final repo = PricingRepository(quantity: 0, isFootlong: true);
      expect(repo.calculateTotal(), 0.0);
    });
  });
}
