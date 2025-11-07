import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(),
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
  int _quantity = 0;
  String _note = '';
  String _sandwichType = 'Footlong'; // 🆕 New state variable
  final TextEditingController _noteController = TextEditingController();

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canAdd = _quantity < widget.maxQuantity;
    final bool canRemove = _quantity > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display sandwich order summary
              OrderItemDisplay(
                _quantity,
                _sandwichType,
              ),

              const SizedBox(height: 20),

              // 🆕 Sandwich type selector
              SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment(
                    value: 'Footlong',
                    label: Text('Footlong'),
                    icon: Icon(Icons.straighten),
                  ),
                  ButtonSegment(
                    value: 'Six-inch',
                    label: Text('Six-inch'),
                    icon: Icon(Icons.cut),
                  ),
                ],
                selected: <String>{_sandwichType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _sandwichType = newSelection.first;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Notes input field
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a note (e.g., "no onions", "extra pickles")',
                ),
                onChanged: (value) => setState(() => _note = value),
              ),

              const SizedBox(height: 20),

              // Add / Remove buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledButton(
                    label: 'Add',
                    icon: Icons.add,
                    color: Colors.green,
                    onPressed: canAdd ? _increaseQuantity : null,
                  ),
                  StyledButton(
                    label: 'Remove',
                    icon: Icons.remove,
                    color: Colors.red,
                    onPressed: canRemove ? _decreaseQuantity : null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Display user note if any
              if (_note.isNotEmpty)
                Text(
                  'Note: $_note',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Styled reusable button
class StyledButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const StyledButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? Colors.grey : color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

// Displays the current sandwich order
class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
      style: const TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}
