part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class OrderAddressUpdated extends OrderEvent {
  const OrderAddressUpdated(this.address);
  final String address;
  @override
  List<Object?> get props => [address];
}

class OrderPaymentMethodUpdated extends OrderEvent {
  const OrderPaymentMethodUpdated(this.method);
  final PaymentMethod method;
  @override
  List<Object?> get props => [method];
}

class OrderPlaced extends OrderEvent {
  const OrderPlaced(this.items);
  final List<CartItem> items;
  @override
  List<Object?> get props => [items];
}

class OrderReset extends OrderEvent {}


