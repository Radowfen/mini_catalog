import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

/// Ürün görseli + akıllı placeholder.
///
/// 1) Asset varsa `Image.asset` ile gösterir.
/// 2) Asset eksikse ürün adından/kategorisinden ikon ve gradient seçer —
///    böylece uygulama görseller olmadan da modern görünür.
class ProductImage extends StatelessWidget {
  final Product product;
  final double iconSize;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;

  const ProductImage({
    super.key,
    required this.product,
    this.iconSize = 56,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Image.asset(
        product.imageAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) {
          return _ProductImageFallback(
            product: product,
            iconSize: iconSize,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  final Product product;
  final double iconSize;
  final BorderRadius? borderRadius;

  const _ProductImageFallback({
    required this.product,
    required this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _gradientFor(product.id);
    final icon = _iconFor(product);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }

  /// Ürün ID'sine göre deterministik bir gradient.
  /// 6 sabit palet → ürünler arasında çeşitlilik.
  static List<Color> _gradientFor(int id) {
    const palettes = <List<Color>>[
      [Color(0xFF6D5BFF), Color(0xFFB44BFF)],
      [Color(0xFFFF6A88), Color(0xFFFF99AC)],
      [Color(0xFF00C9A7), Color(0xFF1FD1F9)],
      [Color(0xFFFFB75E), Color(0xFFED8F03)],
      [Color(0xFF3A86FF), Color(0xFF8338EC)],
      [Color(0xFF2EC4B6), Color(0xFF0077B6)],
    ];
    return palettes[id % palettes.length];
  }

  /// Ürün adı / kategorisinden ikon çıkarımı.
  static IconData _iconFor(Product p) {
    final n = p.name.toLowerCase();
    if (n.contains('airpod')) return Icons.headphones_rounded;
    if (n.contains('homepod')) return Icons.speaker_rounded;
    if (n.contains('iphone')) return Icons.smartphone_rounded;
    if (n.contains('macbook')) return Icons.laptop_mac_rounded;
    if (n.contains('ipad')) return Icons.tablet_mac_rounded;
    if (n.contains('watch')) return Icons.watch_rounded;
    return Icons.devices_other_rounded;
  }
}

/// Detay ekranındaki büyük "podyum" görsel arkaplanı.
/// Asset varsa onu üstte gösterir; yoksa gradient placeholder kullanır.
class ProductHeroImage extends StatelessWidget {
  final Product product;
  const ProductHeroImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: c.cardBackground,
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Soft dekoratif blob
            Positioned(
              left: -40,
              top: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: -50,
              bottom: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.accent.withValues(alpha: 0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(36),
              child: Hero(
                tag: 'product-image-${product.id}',
                child: ProductImage(
                  product: product,
                  iconSize: 96,
                  borderRadius: BorderRadius.circular(28),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
