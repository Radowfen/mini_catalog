/// Ürün modeli.
///
/// Eğitim yönergesindeki Gün 4 hedefine uygun olarak
/// fromJson / toJson dönüşümleri içerir.
class Product {
  final int id;
  final String name;
  final String category; // ör. "Adaptive Audio" — başlık altı slogan
  final String tag; // ör. "audio", "iphone" — filtreleme için
  final double price;
  final String imageAsset; // assets/images/... yolu
  final String description;
  final List<String> specs; // ör. ["3.3 inches", "345 grams", "2 colors"]
  final double rating; // 0–5
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.tag,
    required this.price,
    required this.imageAsset,
    required this.description,
    required this.specs,
    this.rating = 4.7,
    this.reviewCount = 124,
  });

  /// JSON'dan Product nesnesi oluşturur.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      tag: json['tag'] as String? ?? 'other',
      price: (json['price'] as num).toDouble(),
      imageAsset: json['imageAsset'] as String,
      description: json['description'] as String,
      specs: List<String>.from(json['specs'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.7,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 124,
    );
  }

  /// Product nesnesini JSON Map'ine dönüştürür.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tag': tag,
      'price': price,
      'imageAsset': imageAsset,
      'description': description,
      'specs': specs,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  /// $1,299 gibi biçimlendirilmiş fiyat.
  String get formattedPrice {
    final whole = price.toStringAsFixed(0);
    final buf = StringBuffer(r'$');
    for (int i = 0; i < whole.length; i++) {
      buf.write(whole[i]);
      final remaining = whole.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return buf.toString();
  }
}
