part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
  @override
  List<Object?> get props => [];
}

class MenuRequested extends MenuEvent {
  const MenuRequested(this.restaurantId);
  final String restaurantId;
  @override
  List<Object?> get props => [restaurantId];
}


