import 'package:flutter/material.dart';
import '../../presentation/router/app_router.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.args});
  final ConfirmationArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Placed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 72),
              const SizedBox(height: 16),
              Text('Success!', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Your order #${args.orderId} has been placed.'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Back to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }
}


