import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/restaurant.dart';
import '../../repositories/restaurant_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc(this._repository) : super(const RestaurantState.initial()) {
    on<RestaurantsRequested>(_onRestaurantsRequested);
  }

  final IRestaurantRepository _repository;

  Future<void> _onRestaurantsRequested(
    RestaurantsRequested event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(state.copyWith(status: RestaurantStatus.loading));
    try {
      final restaurants = await _repository.fetchRestaurants();
      emit(state.copyWith(status: RestaurantStatus.success, restaurants: restaurants));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: RestaurantStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: RestaurantStatus.failure, errorMessage: 'Unexpected error'));
    }
  }
}


