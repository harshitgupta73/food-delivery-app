import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_app/src/blocs/order/order_bloc.dart';
import 'package:order_app/src/models/cart_item.dart';
import 'package:order_app/src/models/menu_item.dart';
import 'package:order_app/src/models/order.dart';
import 'package:order_app/src/repositories/restaurant_repository.dart';

void main() {
  group('OrderBloc', () {
    final items = [
      CartItem(item: const MenuItem(id: '1', name: 'A', description: '', price: 5, imageUrl: ''), quantity: 2),
    ];

    blocTest<OrderBloc, OrderState>(
      'fails when address missing',
      build: () => OrderBloc(FakeRestaurantRepository()),
      act: (bloc) => bloc.add(OrderPlaced(items)),
      expect: () => [
        isA<OrderState>().having((s) => s.status, 'status', OrderStatus.failure),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'succeeds with address and payment',
      build: () => OrderBloc(FakeRestaurantRepository()),
      act: (bloc) => bloc
        ..add(const OrderAddressUpdated('123 Street'))
        ..add(const OrderPaymentMethodUpdated(PaymentMethod.cashOnDelivery))
        ..add(OrderPlaced(items)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        isA<OrderState>().having((s) => s.address, 'address', '123 Street'),
        isA<OrderState>().having((s) => s.paymentMethod, 'payment', PaymentMethod.cashOnDelivery),
        isA<OrderState>().having((s) => s.status, 'status', OrderStatus.submitting),
        isA<OrderState>().having((s) => s.status, 'status', OrderStatus.success),
      ],
    );
  });
}


