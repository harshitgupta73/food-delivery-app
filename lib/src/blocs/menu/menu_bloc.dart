import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/menu_item.dart';
import '../../repositories/restaurant_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({required IRestaurantRepository repository})
      : _repository = repository,
        super(const MenuState.initial()) {
    on<MenuRequested>(_onMenuRequested);
  }

  final IRestaurantRepository _repository;

  Future<void> _onMenuRequested(MenuRequested event, Emitter<MenuState> emit) async {
    emit(state.copyWith(status: MenuStatus.loading, restaurantId: event.restaurantId));
    try {
      final items = await _repository.fetchMenu(event.restaurantId);
      emit(state.copyWith(status: MenuStatus.success, items: items));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: MenuStatus.failure, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(status: MenuStatus.failure, errorMessage: 'Unexpected error'));
    }
  }
}


