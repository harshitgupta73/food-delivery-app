import 'package:flutter/material.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/checkout_screen.dart';
import '../../presentation/screens/confirmation_screen.dart';
import '../../presentation/screens/menu_screen.dart';
import '../../presentation/screens/restaurant_list_screen.dart';
import '../../presentation/screens/order_history_screen.dart';

class AppRouter {
  static const restaurantList = '/';
  static const menu = '/menu';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const confirmation = '/confirmation';
  static const orderHistory = '/order-history';

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case restaurantList:
        return _createRoute(const RestaurantListScreen());
      case menu:
        final args = settings.arguments as MenuScreenArgs;
        return _createRoute(MenuScreen(args: args));
      case cart:
        return _createRoute(const CartScreen());
      case checkout:
        return _createRoute(const CheckoutScreen());
      case confirmation:
        final args = settings.arguments as ConfirmationArgs;
        return _createRoute(ConfirmationScreen(args: args));
      case orderHistory:
        return _createRoute(const OrderHistoryScreen());
      default:
        return _createRoute(const RestaurantListScreen());
    }
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class MenuScreenArgs {
  const MenuScreenArgs({required this.restaurantId, required this.title});
  final String restaurantId;
  final String title;
}

class ConfirmationArgs {
  const ConfirmationArgs({required this.orderId});
  final String orderId;
}


