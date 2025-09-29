import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/order/order_bloc.dart';
import '../../models/order.dart';
import '../../presentation/router/app_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  PaymentMethod? _method;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final items = context.read<CartBloc>().state.items;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }
    final orderBloc = context.read<OrderBloc>();
    orderBloc.add(OrderAddressUpdated(_addressController.text.trim()));
    if (_method != null) orderBloc.add(OrderPaymentMethodUpdated(_method!));
    orderBloc.add(OrderPlaced(items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.failure && state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
          if (state.status == OrderStatus.success && state.lastOrder != null) {
            context.read<CartBloc>().add(CartCleared());
            Navigator.pushReplacementNamed(
              context,
              AppRouter.confirmation,
              arguments: ConfirmationArgs(orderId: state.lastOrder!.id),
            );
          }
        },
        builder: (context, state) {
          final submitting = state.status == OrderStatus.submitting;
          return AbsorbPointer(
            absorbing: submitting,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Address', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Enter full address', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Address is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    RadioListTile<PaymentMethod>(
                      value: PaymentMethod.cashOnDelivery,
                      groupValue: _method,
                      onChanged: (v) => setState(() => _method = v),
                      title: const Text('Cash on Delivery'),
                    ),
                    RadioListTile<PaymentMethod>(
                      value: PaymentMethod.card,
                      groupValue: _method,
                      onChanged: (v) => setState(() => _method = v),
                      title: const Text('Card'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submitting ? null : () => _placeOrder(context),
                        icon: submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(submitting ? 'Placing Order...' : 'Place Order'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


