part of 'order_bloc.dart';

enum OrderStatus { initial, submitting, success, failure }

class OrderState extends Equatable {
  const OrderState({
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.errorMessage,
    required this.lastOrder,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        address = '',
        paymentMethod = null,
        errorMessage = '',
        lastOrder = null;

  final OrderStatus status;
  final String address;
  final PaymentMethod? paymentMethod;
  final String errorMessage;
  final Order? lastOrder;

  OrderState copyWith({
    OrderStatus? status,
    String? address,
    PaymentMethod? paymentMethod,
    String? errorMessage,
    Order? lastOrder,
  }) {
    return OrderState(
      status: status ?? this.status,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      errorMessage: errorMessage ?? this.errorMessage,
      lastOrder: lastOrder ?? this.lastOrder,
    );
  }

  @override
  List<Object?> get props => [status, address, paymentMethod, errorMessage, lastOrder];
}


