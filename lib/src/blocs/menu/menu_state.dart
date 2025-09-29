part of 'menu_bloc.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  const MenuState({
    required this.status,
    required this.items,
    required this.errorMessage,
    required this.restaurantId,
  });

  const MenuState.initial()
      : status = MenuStatus.initial,
        items = const [],
        errorMessage = '',
        restaurantId = '';

  final MenuStatus status;
  final List<MenuItem> items;
  final String errorMessage;
  final String restaurantId;

  MenuState copyWith({
    MenuStatus? status,
    List<MenuItem>? items,
    String? errorMessage,
    String? restaurantId,
  }) {
    return MenuState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage, restaurantId];
}


