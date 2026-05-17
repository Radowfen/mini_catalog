// Mini Catalog smoke test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_catalog/main.dart';

void main() {
  testWidgets('App boots and shows Discover screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiniCatalogApp());
    await tester.pumpAndSettle();

    // Discover ekranı başlığı tek widget olarak görünür (bottom nav etiketsiz, sadece ikon).
    expect(find.text('Discover'), findsOneWidget);
    // Arama kutusu hint'i
    expect(find.text('Search products'), findsOneWidget);
    // Promosyon banner'ı
    expect(find.text('Up to 30% off'), findsOneWidget);
  });

  testWidgets('Search filters product list', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniCatalogApp());
    await tester.pumpAndSettle();

    // İlk satırdaki AirPods Pro başlangıçta listelenmeli
    expect(find.text('AirPods Pro (2nd Gen)'), findsOneWidget);
    // Üst kısımda görünen "7 items" sayacı (toplam ürün adedi)
    expect(find.text('7 items'), findsOneWidget);

    // Arama kutusuna "airpods" yaz: yalnızca 2 AirPods ürünü kalmalı
    await tester.enterText(find.byType(TextField), 'airpods');
    await tester.pumpAndSettle();

    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('AirPods Pro (2nd Gen)'), findsOneWidget);
  });
}
