import 'package:flutter/material.dart';
import '../models/product.dart';

/// JSON simülasyonu.
///
/// Eğitim yönergesi gerçek bir API kullanımını zorunlu kılmıyor;
/// "fromJson/toJson temel mantığı" + "ListView.builder ile liste oluşturma"
/// hedefi için bu mock veri kullanılır. Gerçek bir uygulamada
/// http paketiyle wantapi.com/products.php veya fakestoreapi.com'dan
/// çekilebilir.
class ProductRepository {
  /// JSON formatında ham veri — gerçek bir API yanıtını taklit eder.
  static const List<Map<String, dynamic>> _rawJson = [
    {
      'id': 1,
      'name': 'AirPods Pro (2nd Gen)',
      'category': 'Adaptive Audio',
      'tag': 'audio',
      'price': 249,
      'imageAsset': 'assets/images/airpods_pro.png',
      'description':
          'AirPods Pro feature up to 2x more Active Noise Cancellation, plus Adaptive Audio that tailors noise control to your surroundings. Personalized Spatial Audio places sound all around you, and a single charge delivers up to 6 hours of listening time.',
      'specs': ['6 hr battery', 'ANC', 'USB-C'],
      'rating': 4.8,
      'reviewCount': 2480,
    },
    {
      'id': 2,
      'name': 'AirPods Max',
      'category': 'Sound. Reinvented.',
      'tag': 'audio',
      'price': 549,
      'imageAsset': 'assets/images/airpods_max.png',
      'description':
          'AirPods Max combine a custom acoustic design, H1 chips, and advanced software to produce the highest-fidelity audio. The result is a magical listening experience with adaptive EQ, Active Noise Cancellation, and spatial audio.',
      'specs': ['20 hr battery', 'ANC', '5 colors'],
      'rating': 4.6,
      'reviewCount': 980,
    },
    {
      'id': 3,
      'name': 'HomePod',
      'category': 'Profound sound',
      'tag': 'audio',
      'price': 299,
      'imageAsset': 'assets/images/homepod.png',
      'description':
          'HomePod is a powerful smart speaker with room-filling, high-fidelity sound that adapts to the location for an immersive listening experience. Designed to work seamlessly with Apple Music and Siri.',
      'specs': ['Room sensing', 'Siri', '2 colors'],
      'rating': 4.5,
      'reviewCount': 612,
    },
    {
      'id': 4,
      'name': 'HomePod Mini',
      'category': 'Color pop.',
      'tag': 'audio',
      'price': 99,
      'imageAsset': 'assets/images/homepod_mini.png',
      'description':
          'The HomePod mini is jam-packed with innovation, delivering unexpectedly big sound from a speaker of its size. At just 3.3 inches tall, it takes up almost no space but fills the entire room with rich 360-degree audio. It works effortlessly with your iPhone — hand off music just by bringing your phone close to the speaker.',
      'specs': ['3.3 inches', '345 grams', '5 colors'],
      'rating': 4.7,
      'reviewCount': 3120,
    },
    {
      'id': 5,
      'name': 'iPhone 15 Pro',
      'category': 'Titanium. So strong. So light.',
      'tag': 'iphone',
      'price': 999,
      'imageAsset': 'assets/images/iphone_15_pro.png',
      'description':
          'iPhone 15 Pro is forged in titanium and features the groundbreaking A17 Pro chip, a customizable Action button, and the most powerful iPhone camera system ever.',
      'specs': ['A17 Pro', '6.1"', 'Titanium'],
      'rating': 4.9,
      'reviewCount': 5240,
    },
    {
      'id': 6,
      'name': 'MacBook Pro 14"',
      'category': 'Mind-blowing. Head-turning.',
      'tag': 'mac',
      'price': 1999,
      'imageAsset': 'assets/images/macbook_pro.png',
      'description':
          'MacBook Pro blasts forward with the M3, M3 Pro, and M3 Max chips. Built for all kinds of creatives, including developers, photographers, filmmakers, and 3D artists.',
      'specs': ['M3 chip', '14-inch', '22 hr battery'],
      'rating': 4.9,
      'reviewCount': 1840,
    },
    {
      'id': 7,
      'name': 'iPad Air',
      'category': 'Light. Bright. Full of might.',
      'tag': 'ipad',
      'price': 599,
      'imageAsset': 'assets/images/ipad_air.png',
      'description':
          'iPad Air features the powerful M1 chip, a stunning 10.9-inch Liquid Retina display, advanced cameras, and ultrafast Wi-Fi 6 and 5G — all in a thin and light design.',
      'specs': ['M1 chip', '10.9"', 'USB-C'],
      'rating': 4.7,
      'reviewCount': 920,
    },
  ];

  /// Tüm ürünleri JSON'dan parse ederek döner.
  static List<Product> fetchAll() {
    return _rawJson.map(Product.fromJson).toList();
  }

  /// Arama (Gün 4: "Basit arama ve filtreleme mantığı").
  static List<Product> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return fetchAll();
    return fetchAll().where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }

  /// Tag'e göre filtreleme (kategori chip'leri için).
  static List<Product> byTag(String tag) {
    if (tag == 'all') return fetchAll();
    return fetchAll().where((p) => p.tag == tag).toList();
  }

  /// Arama + tag birlikte uygulanır.
  static List<Product> filter({required String query, required String tag}) {
    final q = query.trim().toLowerCase();
    return fetchAll().where((p) {
      final matchesTag = tag == 'all' || p.tag == tag;
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchesTag && matchesQuery;
    }).toList();
  }
}

/// UI'da kullanılacak kategori tanımları.
class ProductCategory {
  final String tag;
  final String label;
  final IconData icon;
  const ProductCategory({
    required this.tag,
    required this.label,
    required this.icon,
  });

  static const List<ProductCategory> all = [
    ProductCategory(tag: 'all', label: 'All', icon: Icons.apps_rounded),
    ProductCategory(tag: 'audio', label: 'Audio', icon: Icons.headphones_rounded),
    ProductCategory(tag: 'iphone', label: 'iPhone', icon: Icons.smartphone_rounded),
    ProductCategory(tag: 'mac', label: 'Mac', icon: Icons.laptop_mac_rounded),
    ProductCategory(tag: 'ipad', label: 'iPad', icon: Icons.tablet_mac_rounded),
  ];
}
