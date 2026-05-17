import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/favorites.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Favori ürünler ekranı.
class FavoritesScreen extends StatelessWidget {
  final CartModel cart;
  final FavoritesModel favorites;
  const FavoritesScreen({
    super.key,
    required this.cart,
    required this.favorites,
  });

  void _openDetail(BuildContext context, Product p) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: p,
          cart: cart,
          favorites: favorites,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: favorites,
          builder: (context, _) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 13,
                            color: c.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Favorites',
                          style:
                              Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          favorites.isEmpty
                              ? 'Tap the heart icon to save products.'
                              : '${favorites.count} item${favorites.count == 1 ? '' : 's'} saved',
                          style: TextStyle(
                            fontSize: 13,
                            color: c.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (favorites.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyFavorites(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final p = favorites.items[i];
                          return ProductCard(
                            product: p,
                            favorites: favorites,
                            onTap: () => _openDetail(context, p),
                          );
                        },
                        childCount: favorites.count,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: c.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_outline_rounded,
                size: 44,
                color: c.favorite,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the heart icon on any product to keep it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.secondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
