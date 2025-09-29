import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.imageUrl,
    required this.menu,
  });

  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String imageUrl;
  final List<MenuItem> menu;

  @override
  List<Object?> get props => [id, name, cuisine, rating, imageUrl, menu];

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      menu: (json['menu'] as List<dynamic>)
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cuisine': cuisine,
        'rating': rating,
        'imageUrl': imageUrl,
        'menu': menu.map((e) => e.toJson()).toList(),
      };
}


