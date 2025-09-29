import 'dart:math';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

abstract class IRestaurantRepository {
  Future<List<Restaurant>> fetchRestaurants();
  Future<List<MenuItem>> fetchMenu(String restaurantId);
  Future<void> saveOrder(Order order);
  Future<List<Order>> getOrderHistory();
}

class RepositoryException extends Equatable implements Exception {
  const RepositoryException(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
  @override
  String toString() => message;
}

class FakeRestaurantRepository implements IRestaurantRepository {

  static final List<Restaurant> _restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Pizza Palace',
      cuisine: 'Italian',
      rating: 4.5,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      menu: const [
        MenuItem(
          id: 'm1',
          name: 'Margherita Pizza',
          description: 'Classic cheese and tomato with fresh basil',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
        ),
        MenuItem(
          id: 'm2',
          name: 'Pepperoni Supreme',
          description: 'Spicy pepperoni, mozzarella, and oregano',
          price: 15.99,
          imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
        ),
        MenuItem(
          id: 'm3',
          name: 'Veggie Delight',
          description: 'Loaded with fresh bell peppers, mushrooms, and olives',
          price: 13.99,
          imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        ),
        MenuItem(
          id: 'm4',
          name: 'BBQ Chicken',
          description: 'Grilled chicken with BBQ sauce and red onions',
          price: 16.99,
          imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        ),
        MenuItem(
          id: 'm5',
          name: 'Quattro Stagioni',
          description: 'Four seasons with artichokes, mushrooms, ham, and olives',
          price: 18.99,
          imageUrl: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
        ),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'Spicy Hub',
      cuisine: 'Indian',
      rating: 4.3,
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800',
      menu: const [
        MenuItem(
          id: 'm6',
          name: 'Butter Chicken',
          description: 'Tender chicken in creamy tomato gravy with basmati rice',
          price: 14.99,
          imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        ),
        MenuItem(
          id: 'm7',
          name: 'Paneer Tikka Masala',
          description: 'Cottage cheese in rich tomato and cream sauce',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d4d4?w=400',
        ),
        MenuItem(
          id: 'm8',
          name: 'Chicken Biryani',
          description: 'Aromatic basmati rice with spiced chicken and raita',
          price: 13.99,
          imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400',
        ),
        MenuItem(
          id: 'm9',
          name: 'Dal Makhani',
          description: 'Creamy black lentils with butter and cream',
          price: 9.99,
          imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400',
        ),
        MenuItem(
          id: 'm10',
          name: 'Tandoori Chicken',
          description: 'Marinated chicken cooked in clay oven with mint chutney',
          price: 15.99,
          imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d4d4?w=400',
        ),
      ],
    ),
    Restaurant(
      id: 'r3',
      name: 'Sushi Master',
      cuisine: 'Japanese',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
      menu: const [
        MenuItem(
          id: 'm11',
          name: 'Salmon Sashimi',
          description: 'Fresh Atlantic salmon, 8 pieces',
          price: 18.99,
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        ),
        MenuItem(
          id: 'm12',
          name: 'California Roll',
          description: 'Crab, avocado, cucumber with sesame seeds',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400',
        ),
        MenuItem(
          id: 'm13',
          name: 'Dragon Roll',
          description: 'Eel, cucumber, avocado with eel sauce',
          price: 16.99,
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        ),
        MenuItem(
          id: 'm14',
          name: 'Chicken Teriyaki',
          description: 'Grilled chicken with teriyaki sauce and steamed rice',
          price: 14.99,
          imageUrl: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400',
        ),
        MenuItem(
          id: 'm15',
          name: 'Miso Soup',
          description: 'Traditional Japanese soup with tofu and seaweed',
          price: 4.99,
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        ),
      ],
    ),
    Restaurant(
      id: 'r4',
      name: 'Burger Junction',
      cuisine: 'American',
      rating: 4.2,
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800',
      menu: const [
        MenuItem(
          id: 'm16',
          name: 'Classic Cheeseburger',
          description: 'Beef patty, cheese, lettuce, tomato, onion, pickles',
          price: 11.99,
          imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        ),
        MenuItem(
          id: 'm17',
          name: 'BBQ Bacon Burger',
          description: 'Beef patty, bacon, BBQ sauce, onion rings',
          price: 14.99,
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        ),
        MenuItem(
          id: 'm18',
          name: 'Chicken Deluxe',
          description: 'Grilled chicken breast, avocado, Swiss cheese',
          price: 13.99,
          imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        ),
        MenuItem(
          id: 'm19',
          name: 'Veggie Supreme',
          description: 'Plant-based patty, vegan cheese, fresh vegetables',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        ),
        MenuItem(
          id: 'm20',
          name: 'Loaded Fries',
          description: 'Crispy fries with cheese, bacon, and jalapeños',
          price: 8.99,
          imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        ),
      ],
    ),
    Restaurant(
      id: 'r5',
      name: 'Thai Garden',
      cuisine: 'Thai',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      menu: const [
        MenuItem(
          id: 'm21',
          name: 'Pad Thai',
          description: 'Stir-fried rice noodles with shrimp, tofu, and peanuts',
          price: 13.99,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
        ),
        MenuItem(
          id: 'm22',
          name: 'Green Curry',
          description: 'Coconut curry with chicken, eggplant, and basil',
          price: 14.99,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
        ),
        MenuItem(
          id: 'm23',
          name: 'Tom Yum Soup',
          description: 'Spicy and sour soup with shrimp and mushrooms',
          price: 9.99,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
        ),
        MenuItem(
          id: 'm24',
          name: 'Mango Sticky Rice',
          description: 'Sweet sticky rice with fresh mango and coconut milk',
          price: 7.99,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
        ),
        MenuItem(
          id: 'm25',
          name: 'Thai Iced Tea',
          description: 'Traditional spiced tea with condensed milk',
          price: 4.99,
          imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=400',
        ),
      ],
    ),
    Restaurant(
      id: 'r6',
      name: 'Mediterranean Breeze',
      cuisine: 'Mediterranean',
      rating: 4.4,
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800',
      menu: const [
        MenuItem(
          id: 'm26',
          name: 'Greek Salad',
          description: 'Fresh tomatoes, cucumbers, olives, feta cheese',
          price: 10.99,
          imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ),
        MenuItem(
          id: 'm27',
          name: 'Chicken Shawarma',
          description: 'Marinated chicken with garlic sauce and pita bread',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ),
        MenuItem(
          id: 'm28',
          name: 'Hummus Platter',
          description: 'Creamy hummus with pita bread and vegetables',
          price: 8.99,
          imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ),
        MenuItem(
          id: 'm29',
          name: 'Falafel Wrap',
          description: 'Crispy falafel with tahini sauce and fresh vegetables',
          price: 9.99,
          imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ),
        MenuItem(
          id: 'm30',
          name: 'Baklava',
          description: 'Sweet pastry with nuts and honey syrup',
          price: 6.99,
          imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ),
      ],
    ),
  ];

  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    // Return shallow copies without heavy menus for list view
    return _restaurants
        .map((r) => Restaurant(
              id: r.id,
              name: r.name,
              cuisine: r.cuisine,
              rating: r.rating,
              imageUrl: r.imageUrl,
              menu: const [],
            ))
        .toList();
  }

  @override
  Future<List<MenuItem>> fetchMenu(String restaurantId) async {
    final restaurant = _restaurants.firstWhere((r) => r.id == restaurantId, orElse: () => _restaurants.first);
    return restaurant.menu;
  }

  @override
  Future<void> saveOrder(Order order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getStringList('orders') ?? [];
      ordersJson.add(jsonEncode({
        'id': order.id,
        'items': order.items.map((item) => {
          'item': {
            'id': item.item.id,
            'name': item.item.name,
            'description': item.item.description,
            'price': item.item.price,
            'imageUrl': item.item.imageUrl,
          },
          'quantity': item.quantity,
        }).toList(),
        'address': order.address,
        'paymentMethod': order.paymentMethod.name,
        'total': order.total,
        'placedAt': order.placedAt.toIso8601String(),
      }));
      await prefs.setStringList('orders', ordersJson);
    } catch (e) {
      throw RepositoryException('Failed to save order: $e');
    }
  }

  @override
  Future<List<Order>> getOrderHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getStringList('orders') ?? [];
      return ordersJson.map((orderStr) {
        final orderData = jsonDecode(orderStr) as Map<String, dynamic>;
        return Order(
          id: orderData['id'] as String,
          items: (orderData['items'] as List<dynamic>).map((itemData) {
            final item = itemData['item'] as Map<String, dynamic>;
            return CartItem(
              item: MenuItem(
                id: item['id'] as String,
                name: item['name'] as String,
                description: item['description'] as String,
                price: (item['price'] as num).toDouble(),
                imageUrl: item['imageUrl'] as String,
              ),
              quantity: itemData['quantity'] as int,
            );
          }).toList(),
          address: orderData['address'] as String,
          paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name == orderData['paymentMethod'],
            orElse: () => PaymentMethod.cashOnDelivery,
          ),
          total: (orderData['total'] as num).toDouble(),
          placedAt: DateTime.parse(orderData['placedAt'] as String),
        );
      }).toList();
    } catch (e) {
      throw RepositoryException('Failed to load order history: $e');
    }
  }
}


