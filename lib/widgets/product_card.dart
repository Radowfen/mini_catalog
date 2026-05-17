import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorites.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';

/// GridView için ürün kartı.
///
/// Gün 5 hedefi: "GridView ile ürün kartları".
/// Modern dokunuşlar: favori butonu, gradient placeholder, basılı durum animasyonu.
class ProductCard extends StatefulWidget {
  final Product product;
  final FavoritesModel favorites;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.favorites,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: c.cardBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.divider.withValues(alpha: 0.6)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'product-image-${widget.product.id}',
                        child: ProductImage(
                          product: widget.product,
                          iconSize: 44,
                          borderRadius: BorderRadius.circular(18),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _FavoriteButton(
                        product: widget.product,
                        favorites: widget.favorites,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.primary,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.product.category,
                style: TextStyle(fontSize: 11, color: c.secondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.product.formattedPrice,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: c.primary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: c.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final Product product;
  final FavoritesModel favorites;
  const _FavoriteButton({required this.product, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedBuilder(
      animation: favorites,
      builder: (context, _) {
        final isFav = favorites.contains(product);
        return GestureDetector(
          onTap: () => favorites.toggle(product),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: c.elevatedSurface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                key: ValueKey(isFav),
                size: 18,
                color: isFav ? c.favorite : c.secondary,
              ),
            ),
          ),
        );
      },
    );
  }
}
