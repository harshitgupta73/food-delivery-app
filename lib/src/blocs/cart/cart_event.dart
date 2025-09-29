part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.item);
  final MenuItem item;
  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);
  final String itemId;
  @override
  List<Object?> get props => [itemId];
}

class CartItemQuantityUpdated extends CartEvent {
  const CartItemQuantityUpdated({required this.itemId, required this.quantity});
  final String itemId;
  final int quantity;
  @override
  List<Object?> get props => [itemId, quantity];
}

class CartCleared extends CartEvent {}


