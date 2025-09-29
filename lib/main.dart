import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/blocs/cart/cart_bloc.dart';
import 'src/blocs/menu/menu_bloc.dart';
import 'src/blocs/order/order_bloc.dart';
import 'src/blocs/restaurant/restaurant_bloc.dart';
import 'src/presentation/router/app_router.dart';
import 'src/repositories/restaurant_repository.dart';

void main() {
  final repository = FakeRestaurantRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final IRestaurantRepository repository;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IRestaurantRepository>.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => RestaurantBloc(repository)..add(RestaurantsRequested()),
          ),
          BlocProvider(create: (_) => MenuBloc(repository: repository)),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => OrderBloc(repository)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Order App',
          theme: ThemeData(
            colorSchemeSeed: Colors.deepOrange,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          onGenerateRoute: appRouter.onGenerateRoute,
          initialRoute: AppRouter.restaurantList,
        ),
      ),
    );
  }
}


