import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/quantity_selector.dart';

/// Sepet ekranı.
///
/// İki durumu vardır:
/// - Boş: ikon + "Your cart is empty"
/// - Dolu: swipe-to-dismiss ürün listesi + summary + Checkout
class CartScreen extends StatelessWidget {
  final CartModel cart;
  final bool showBackButton;
  const CartScreen({
    super.key,
    required this.cart,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: cart,
          builder: (context, _) {
            return Column(
              children: [
                _CartHeader(
                  itemCount: cart.itemCount,
                  showBackButton: showBackButton,
                ),
                Expanded(
                  child: cart.isEmpty
                      ? const _EmptyCartView()
                      : _FilledCartView(cart: cart),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return _CheckoutBar(cart: cart);
        },
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  final int itemCount;
  final bool showBackButton;
  const _CartHeader({required this.itemCount, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(showBackButton ? 4 : 20, 12, 20, 4),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your bag',
                style: TextStyle(
                  fontSize: 13,
                  color: c.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Cart',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          const Spacer(),
          if (itemCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$itemCount item${itemCount == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

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
                Icons.shopping_cart_outlined,
                size: 42,
                color: c.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Browse the catalog and add some products.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.secondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledCartView extends StatelessWidget {
  final CartModel cart;
  const _FilledCartView({required this.cart});

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    // Gün 4 hedefi: ListView.builder. ListView.separated da builder pattern'i kullanır.
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final item = items[i];
        return Dismissible(
          key: ValueKey(item.product.id),
          direction: DismissDirection.endToStart,
          background: _SwipeDeleteBackground(),
          onDismissed: (_) => cart.remove(item.product),
          child: _CartRow(
            item: item,
            onIncrement: () => cart.increment(item.product),
            onDecrement: () => cart.decrement(item.product),
            onRemove: () => cart.remove(item.product),
          ),
        );
      },
    );
  }
}

class _SwipeDeleteBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.favorite.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(Icons.delete_outline_rounded, color: c.favorite, size: 24),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartRow({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.divider.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ProductImage(
              product: item.product,
              iconSize: 28,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.all(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.product.category,
                  style: TextStyle(fontSize: 11, color: c.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      item.product.formattedPrice,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: c.primary,
                      ),
                    ),
                    const Spacer(),
                    QuantitySelector(
                      value: item.quantity,
                      compact: true,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final CartModel cart;
  const _CheckoutBar({required this.cart});

  void _placeOrder(BuildContext context) {
    final c = AppColors.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: Icon(Icons.check_circle_rounded, color: c.success, size: 56),
        title: const Text('Order placed!'),
        content: Text(
          'Total: ${cart.formattedTotal}\nThank you for your purchase.',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                cart.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
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
            _SummaryRow(label: 'Subtotal', value: cart.formattedTotal),
            const SizedBox(height: 6),
            _SummaryRow(label: 'Shipping', value: 'Free', muted: true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: c.divider, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
                Text(
                  cart.formattedTotal,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: c.primary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _placeOrder(context),
              icon: const Icon(Icons.lock_outline_rounded, size: 18),
              label: const Text('Checkout securely'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool muted;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: c.secondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: muted ? c.success : c.primary,
          ),
        ),
      ],
    );
  }
}
