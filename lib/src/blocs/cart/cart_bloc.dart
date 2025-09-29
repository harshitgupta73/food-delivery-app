import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import '../../models/menu_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState.initial()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartCleared>(_onCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((e) => e.item.id == event.item.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(item: event.item, quantity: 1));
    }
    emit(state.copyWith(items: items));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final items = state.items.where((e) => e.item.id != event.itemId).toList();
    emit(state.copyWith(items: items));
  }

  void _onQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((e) => e.item.id == event.itemId);
    if (idx >= 0) {
      final newQty = event.quantity;
      if (newQty <= 0) {
        items.removeAt(idx);
      } else {
        items[idx] = items[idx].copyWith(quantity: newQty);
      }
    }
    emit(state.copyWith(items: items));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(state.copyWith(items: const []));
  }
}


