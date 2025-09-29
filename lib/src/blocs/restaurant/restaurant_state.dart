part of 'restaurant_bloc.dart';

enum RestaurantStatus { initial, loading, success, failure }

class RestaurantState extends Equatable {
  const RestaurantState({
    required this.status,
    required this.restaurants,
    required this.errorMessage,
  });

  const RestaurantState.initial()
      : status = RestaurantStatus.initial,
        restaurants = const [],
        errorMessage = '';

  final RestaurantStatus status;
  final List<Restaurant> restaurants;
  final String errorMessage;

  RestaurantState copyWith({
    RestaurantStatus? status,
    List<Restaurant>? restaurants,
    String? errorMessage,
  }) {
    return RestaurantState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, restaurants, errorMessage];
}


