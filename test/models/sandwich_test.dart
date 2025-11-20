import 'package:flutter_test/flutter_test.dart';

enum SandwichType { veggieDelight, chickenTeriyaki, tunaMelt, meatballMarinara }
enum BreadType { white, wheat, wholemeal }

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({required this.type, required this.isFootlong, required this.breadType});

  // Build readable name from enum name: 'veggieDelight' -> 'Veggie Delight'
  String get name {
    final raw = type.name;
    final spaced = raw.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}');
    return spaced.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  // Build asset path depending on isFootlong
  String get image {
    final size = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${type.name}_$size.png';
  }
}

void main() {
  group('Sandwich model', () {
    test('name getter returns readable name for each type', () {
      expect(
        Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.white).name,
        'Veggie Delight',
      );

      expect(
        Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: false, breadType: BreadType.white).name,
        'Chicken Teriyaki',
      );

      expect(
        Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.white).name,
        'Tuna Melt',
      );

      expect(
        Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.white).name,
        'Meatball Marinara',
      );
    });

    test('image getter builds correct asset path for six_inch and footlong', () {
      final six = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.wheat);
      expect(six.image, 'assets/images/${SandwichType.tunaMelt.name}_six_inch.png');

      final foot = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.wheat);
      expect(foot.image, 'assets/images/${SandwichType.tunaMelt.name}_footlong.png');
    });

    test('stores breadType and isFootlong values', () {
      final s = Sandwich(type: SandwichType.meatballMarinara, isFootlong: true, breadType: BreadType.wholemeal);
      expect(s.breadType, BreadType.wholemeal);
      expect(s.isFootlong, true);
    });
  });
}
