import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum PaymentMethod { cashOnDelivery, card }

class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.total,
    required this.placedAt,
  });

  final String id;
  final List<CartItem> items;
  final String address;
  final PaymentMethod paymentMethod;
  final double total;
  final DateTime placedAt;

  @override
  List<Object?> get props => [id, items, address, paymentMethod, total, placedAt];
}


