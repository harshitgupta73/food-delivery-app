import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_app/src/blocs/cart/cart_bloc.dart';
import 'package:order_app/src/models/menu_item.dart';

void main() {
  group('CartBloc', () {
    final pizza = const MenuItem(
      id: 'p1',
      name: 'Pizza',
      description: 'Cheesy',
      price: 10.0,
      imageUrl: '',
    );

    blocTest<CartBloc, CartState>(
      'adds item and updates total',
      build: () => CartBloc(),
      act: (bloc) => bloc..add(CartItemAdded(pizza)),
      expect: () => [isA<CartState>().having((s) => s.total, 'total', 10.0)],
    );

    blocTest<CartBloc, CartState>(
      'updates quantity and removes when zero',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(CartItemAdded(pizza))
        ..add(const CartItemQuantityUpdated(itemId: 'p1', quantity: 2))
        ..add(const CartItemQuantityUpdated(itemId: 'p1', quantity: 0)),
      expect: () => [
        isA<CartState>().having((s) => s.items.length, 'len', 1),
        isA<CartState>().having((s) => s.items.first.quantity, 'qty', 2),
        isA<CartState>().having((s) => s.items.isEmpty, 'empty', true),
      ],
    );
  });
}


