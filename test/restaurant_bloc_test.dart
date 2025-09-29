import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_app/src/blocs/restaurant/restaurant_bloc.dart';
import 'package:order_app/src/repositories/restaurant_repository.dart';

class NoFailRepository extends FakeRestaurantRepository {
  NoFailRepository() : super(failureRate: 0);
}

void main() {
  group('RestaurantBloc', () {
    blocTest<RestaurantBloc, RestaurantState>(
      'emits loading then success',
      build: () => RestaurantBloc(NoFailRepository()),
      act: (bloc) => bloc.add(RestaurantsRequested()),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        isA<RestaurantState>().having((s) => s.status, 'status', RestaurantStatus.loading),
        isA<RestaurantState>().having((s) => s.status, 'status', RestaurantStatus.success),
      ],
    );
  });
}


