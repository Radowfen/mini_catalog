import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/favorites.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/quantity_selector.dart';

/// Ürün detay ekranı.
///
/// Gün 3 hedefi: "Sayfalar arası veri taşıma (Route Arguments)" —
/// burada Product constructor argümanı olarak iletilir.
///
/// Gün 5 hedefi: "Sepet butonu ile basit state güncelleme".
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final CartModel cart;
  final FavoritesModel favorites;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cart,
    required this.favorites,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DetailAppBar(
              product: widget.product,
              favorites: widget.favorites,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductHeroImage(product: widget.product),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              _RatingBadge(
                                rating: widget.product.rating,
                                reviewCount: widget.product.reviewCount,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.product.category,
                            style: TextStyle(
                              color: c.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 22),
                          const _SectionLabel('Description'),
                          const SizedBox(height: 10),
                          Text(
                            widget.product.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.55,
                              color: c.primary.withValues(alpha: 0.88),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _SectionLabel('Specifications'),
                          const SizedBox(height: 12),
                          _SpecsRow(specs: widget.product.specs),
                          const SizedBox(height: 22),
                          _DeliveryStrip(),
                          const SizedBox(height: 110),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BuyBar(
        product: widget.product,
        quantity: _quantity,
        onIncrement: () => setState(() => _quantity++),
        onDecrement: () =>
            setState(() => _quantity = (_quantity - 1).clamp(1, 99)),
        onAddToCart: () {
          widget.cart.add(widget.product, quantity: _quantity);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  '${widget.product.name} × $_quantity added to cart',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
        },
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final Product product;
  final FavoritesModel favorites;
  const _DetailAppBar({required this.product, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          AnimatedBuilder(
            animation: favorites,
            builder: (context, _) {
              final isFav = favorites.contains(product);
              return _CircleIcon(
                icon: isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                iconColor: isFav ? c.favorite : null,
                onTap: () => favorites.toggle(product),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 18, color: iconColor ?? c.primary),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;
  const _RatingBadge({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade600),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.primary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(fontSize: 11, color: c.secondary),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: c.primary,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _SpecsRow extends StatelessWidget {
  final List<String> specs;
  const _SpecsRow({required this.specs});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      decoration: BoxDecoration(
        color: c.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (int i = 0; i < specs.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Text(
                    specs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: c.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labelFor(i),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: c.secondary),
                  ),
                ],
              ),
            ),
            if (i != specs.length - 1)
              Container(
                width: 1,
                height: 32,
                color: c.divider,
              ),
          ],
        ],
      ),
    );
  }

  String _labelFor(int index) {
    const labels = ['Feature', 'Detail', 'Variant'];
    if (index < labels.length) return labels[index];
    return '';
  }
}

class _DeliveryStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, size: 20, color: c.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free delivery',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Arrives in 2–3 days',
                  style: TextStyle(fontSize: 11, color: c.secondary),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 22, color: c.secondary),
        ],
      ),
    );
  }
}

class _BuyBar extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const _BuyBar({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final lineTotal = product.price * quantity;
    final formatted = _formatPrice(lineTotal);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: c.background,
          border: Border(top: BorderSide(color: c.divider.withValues(alpha: 0.6))),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: c.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatted,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: c.primary,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                QuantitySelector(
                  value: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onAddToCart,
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPrice(double value) {
    final whole = value.toStringAsFixed(0);
    final buf = StringBuffer(r'$');
    for (int i = 0; i < whole.length; i++) {
      buf.write(whole[i]);
      final remaining = whole.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }
}
