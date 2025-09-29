import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/menu/menu_bloc.dart';
import '../../presentation/router/app_router.dart';
import '../../presentation/widgets/cart_badge.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.args});
  final MenuScreenArgs args;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(MenuRequested(widget.args.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.args.title,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Delicious food delivered to your door',
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

          // Menu Items
          BlocConsumer<MenuBloc, MenuState>(
            listener: (context, state) {
              if (state.status == MenuStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              switch (state.status) {
                case MenuStatus.loading:
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildShimmerCard(),
                        childCount: 8,
                      ),
                    ),
                  );
                case MenuStatus.success:
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.items[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: _buildMenuItemCard(context, item, index),
                          );
                        },
                        childCount: state.items.length,
                      ),
                    ),
                  );
                case MenuStatus.failure:
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
                            'Failed to load menu',
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
                case MenuStatus.initial:
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                      width: 200,
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
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, item, int index) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.food_bank, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\Rs${item.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              // Add haptic feedback
                              // HapticFeedback.lightImpact();
                              context.read<CartBloc>().add(CartItemAdded(item));
                              
                              // Show success animation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text('${item.name} added to cart'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


