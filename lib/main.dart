import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // remove `const` so children can use non-const TextStyles at runtime
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  bool _isToasted = false;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  // store latest confirmation message for persistent UI display
  String _lastConfirmation = '';
  
  // derive a smaller heading style from heading1 so quantity text has a valid style
  TextStyle get heading2 {
    try {
      // heading1 comes from app_styles.dart; derive a slightly smaller variant
      return heading1.copyWith(
        fontSize: (heading1.fontSize ?? 20) * 0.9,
      );
    } catch (_) {
      // fallback if heading1 isn't available for some reason
      return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    }
  }

  // NEW: tracked derived cart state so UI shows total quantities and last-added subtotal
  int _cartItemCount = 0; // total quantity across all entries
  double _cartTotal = 0.0; // total price across cart
  int? _lastAddedQuantity; // quantity added in the most recent add action
  double? _lastAddedSubtotal; // subtotal (price * qty) of the most recent add action

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });

    // initialize tracked values from the cart (cart is empty at start, but kept for completeness)
    _cartItemCount = _computeTotalItemsFromCart();
    _cartTotal = _cart.totalPrice();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int _computeTotalItemsFromCart() {
    try {
      final values = _cart.entries;
      // If entries is a Map, sum the quantities
      if (values is Map) {
        return (values.values).fold<int>(0, (prev, e) => prev + (e as int));
      }

      // If entries is an Iterable (like List), try to sum explicit quantities
      int sum = 0;
      for (final e in values) {
        if (e is int) {
          sum += e as int;
        } else {
          try {
            final qty = (e as dynamic).quantity as int;
            sum += qty;
          } catch (_) {}
        }
      }
      return sum;
        } catch (_) {
      // ignore and default to 0
    }
    return 0;
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      // capture previous totals so we can compute the delta (last-added subtotal)
      final double prevTotal = _cart.totalPrice();
      // (prev item count not required here)

      setState(() {
        _cart.add(sandwich, quantity: _quantity);
      });

      // recompute totals from cart after adding
      final double newTotal = _cart.totalPrice();
      final int newItemCount = _computeTotalItemsFromCart();

      final sizeText = _isFootlong ? 'footlong' : 'six-inch';
      final confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      // show transient SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(confirmationMessage)),
      );

      // store message for persistent display and update tracked totals & last-added info
      setState(() {
        _lastConfirmation = confirmationMessage;

        _cartItemCount = newItemCount;
        _cartTotal = newTotal;

        _lastAddedQuantity = _quantity;
        // compute delta safely (in case of rounding)
        _lastAddedSubtotal = (newTotal - prevTotal).abs();
      });

      debugPrint(confirmationMessage);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich =
          Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // remove const so heading1 (non-const TextStyle) is allowed
        title: Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // remove const here as normalText is not const
                    return Center(
                      child: Text(
                        'Image not found',
                        style: normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // remove const because normalText is not const
                  Text('six-inch', style: normalText),
                  Switch(
                    key: const Key('size_switch'),
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  Text('footlong', style: normalText),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('untoasted', style: normalText),
                  Switch(
                    key: const Key('toast_switch'),
                    value: _isToasted,
                    onChanged: (value) {
                      setState(() => _isToasted = value);
                    },
                  ),
                  Text('toasted', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  // show quantity using heading2 but force black color so it's visible
                  Text('$_quantity', style: heading2.copyWith(color: Colors.black)),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 12),

              // persistent confirmation message (non-intrusive)
              if (_lastConfirmation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _lastConfirmation,
                    key: const Key('last_confirmation'),
                    style: normalText,
                  ),
                ),

              const SizedBox(height: 12),

              // UPDATED: Permanent cart summary showing total item count, total price,
              // and the most-recently-added quantity + subtotal.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Cart: $_cartItemCount items',
                      key: const Key('cart_item_count'),
                      style: normalText,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: £${_cartTotal.toStringAsFixed(2)}',
                      key: const Key('cart_total_price'),
                      style: heading1.copyWith(color: Colors.green),
                    ),
                    if (_lastAddedQuantity != null && _lastAddedSubtotal != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Last added: ${_lastAddedQuantity} x — £${_lastAddedSubtotal!.toStringAsFixed(2)}',
                          key: const Key('cart_last_added'),
                          style: normalText,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

extension on List<CartEntry> {
  get values => null;
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}