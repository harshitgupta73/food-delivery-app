import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  @override
  List<Object?> get props => [id, name, description, price, imageUrl];

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };
}


