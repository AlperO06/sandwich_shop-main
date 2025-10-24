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
  String _note = ''; // 👈 store user's note

  final TextEditingController _noteController = TextEditingController();

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
        print('Current quantity: $_quantity');
      });
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose(); // cleanup the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              OrderItemDisplay(
                _quantity,
                'Footlong',
              ),
              const SizedBox(height: 20),
              // 👇 TextField for adding a note
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a note (e.g., "no onions", "extra pickles")',
                ),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // 👇 Use our new StyledButton widgets here
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // buttons apart
                children: [
                  StyledButton(
                    label: 'Add',
                    icon: Icons.add,
                    color: Colors.green,
                    onPressed: _increaseQuantity,
                  ),
                  StyledButton(
                    label: 'Remove',
                    icon: Icons.remove,
                    color: Colors.red,
                    onPressed: _decreaseQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 👇 Display the note below the buttons
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

// 👇 Reusable custom button widget
class StyledButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const StyledButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

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
