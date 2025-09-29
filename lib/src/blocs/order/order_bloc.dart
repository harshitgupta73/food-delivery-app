import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../repositories/restaurant_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._repository) : super(const OrderState.initial()) {
    on<OrderAddressUpdated>(_onAddressUpdated);
    on<OrderPaymentMethodUpdated>(_onPaymentUpdated);
    on<OrderPlaced>(_onOrderPlaced);
    on<OrderReset>(_onReset);
  }

  final IRestaurantRepository _repository;

  void _onAddressUpdated(OrderAddressUpdated event, Emitter<OrderState> emit) {
    emit(state.copyWith(address: event.address));
  }

  void _onPaymentUpdated(OrderPaymentMethodUpdated event, Emitter<OrderState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  Future<void> _onOrderPlaced(OrderPlaced event, Emitter<OrderState> emit) async {
    if (state.address.trim().isEmpty) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: 'Address required'));
      return;
    }
    if (state.paymentMethod == null) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: 'Select payment method'));
      return;
    }
    emit(state.copyWith(status: OrderStatus.submitting, errorMessage: ''));
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: event.items,
        address: state.address,
        paymentMethod: state.paymentMethod!,
        total: event.items.fold(0, (s, e) => s + e.subtotal),
        placedAt: DateTime.now(),
      );
      await _repository.saveOrder(order);
      emit(state.copyWith(status: OrderStatus.success, lastOrder: order));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: 'Failed to place order: $e'));
    }
  }

  void _onReset(OrderReset event, Emitter<OrderState> emit) {
    emit(const OrderState.initial());
  }
}


