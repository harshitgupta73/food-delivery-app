import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../blocs/restaurant/restaurant_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../presentation/router/app_router.dart';
import '../../presentation/widgets/cart_badge.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Italian', 'Indian', 'Japanese', 'American', 'Thai', 'Mediterranean'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterRestaurants(List<dynamic> restaurants) {
    var filtered = restaurants.where((restaurant) {
      final matchesSearch = restaurant.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || restaurant.cuisine == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good morning! 👋',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'What would you like to order?',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            CartBadge(
                              onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search for restaurants or dishes...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Filters
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: EdgeInsets.only(right: index < _filters.length - 1 ? 8 : 0),
                    child: _buildFilterChip(filter, isSelected),
                  );
                },
              ),
            ),
          ),

          // Restaurants List
          BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, state) {
              switch (state.status) {
                case RestaurantStatus.loading:
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildShimmerCard(),
                        childCount: 6,
                      ),
                    ),
                  );
                case RestaurantStatus.failure:
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Something went wrong',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                case RestaurantStatus.success:
                  final filteredRestaurants = _filterRestaurants(state.restaurants);
                  if (filteredRestaurants.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty || _selectedFilter != 'All'
                                  ? 'No restaurants found matching your search'
                                  : 'No restaurants found',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            if (_searchController.text.isNotEmpty || _selectedFilter != 'All')
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _selectedFilter = 'All';
                                    });
                                  },
                                  child: const Text('Clear Filters'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final restaurant = filteredRestaurants[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: _buildRestaurantCard(context, restaurant, index),
                          );
                        },
                        childCount: filteredRestaurants.length,
                      ),
                    ),
                  );
                case RestaurantStatus.initial:
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final itemCount = state.items.fold<int>(0, (s, e) => s + e.quantity);
          if (itemCount == 0) return const SizedBox.shrink();
          
          return FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text(
              'View Cart ($itemCount)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, restaurant, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.menu,
            arguments: MenuScreenArgs(restaurantId: restaurant.id, title: restaurant.name),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: restaurant.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, size: 50),
                    ),
                  ),
                  // Delivery time badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${20 + (index * 5)} min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Restaurant Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          restaurant.cuisine,
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '0.5 km away',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.delivery_dining, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Free delivery',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Icon(Icons.verified, size: 16, color: Colors.blue[600]),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       'Verified • Safe & Hygienic',
                  //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //             color: Colors.blue[600],
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


