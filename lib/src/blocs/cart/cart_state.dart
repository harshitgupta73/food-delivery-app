part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({required this.items});

  const CartState.initial() : items = const [];

  final List<CartItem> items;

  double get total => items.fold(0, (sum, e) => sum + e.subtotal);

  CartState copyWith({List<CartItem>? items}) => CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}


