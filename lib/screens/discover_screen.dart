import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/favorites.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/gift_store_banner.dart';
import '../widgets/category_chips.dart';
import 'product_detail_screen.dart';

/// Discover ekranı — ana ürün listesi.
///
/// İçerir:
/// - Selamlama başlığı ("Discover")
/// - Arama kutusu (Gün 4: arama/filtreleme)
/// - Promosyon banner'ı
/// - Kategori chip'leri
/// - 2 kolonlu GridView (Gün 5)
class DiscoverScreen extends StatefulWidget {
  final CartModel cart;
  final FavoritesModel favorites;
  const DiscoverScreen({
    super.key,
    required this.cart,
    required this.favorites,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _tag = 'all';

  List<Product> get _products =>
      ProductRepository.filter(query: _query, tag: _tag);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) => setState(() => _query = query);
  void _onTagChanged(String tag) => setState(() => _tag = tag);

  void _openDetail(Product p) {
    // Gün 3: Navigator.push + MaterialPageRoute + arguments
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: p,
          cart: widget.cart,
          favorites: widget.favorites,
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
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Emre 👋',
                              style: TextStyle(
                                fontSize: 13,
                                color: c.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Discover',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        _AvatarBubble(),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        prefixIcon: const Icon(Icons.search_rounded, size: 22),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const GiftStoreBanner(),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryChips(
                selectedTag: _tag,
                onChanged: _onTagChanged,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tag == 'all'
                          ? 'Featured products'
                          : '${ProductCategory.all.firstWhere((c) => c.tag == _tag).label} products',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${_products.length} items',
                      style: TextStyle(fontSize: 12, color: c.secondary),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              sliver: _products.isEmpty
                  ? const SliverToBoxAdapter(child: _EmptySearchResult())
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final p = _products[i];
                          return ProductCard(
                            product: p,
                            favorites: widget.favorites,
                            onTap: () => _openDetail(p),
                          );
                        },
                        childCount: _products.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: c.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: c.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              color: c.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different search or category',
            style: TextStyle(color: c.secondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: c.bannerGradient,
        ),
      ),
      child: const Center(
        child: Text(
          'E',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
