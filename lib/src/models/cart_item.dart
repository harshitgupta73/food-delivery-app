import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class CartItem extends Equatable {
  const CartItem({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  CartItem copyWith({MenuItem? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  double get subtotal => item.price * quantity;

  @override
  List<Object?> get props => [item, quantity];
}


