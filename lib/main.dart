import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'models/favorites.dart';
import 'screens/main_shell.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_notifier.dart';

void main() {
  runApp(const MiniCatalogApp());
}

class MiniCatalogApp extends StatefulWidget {
  const MiniCatalogApp({super.key});

  @override
  State<MiniCatalogApp> createState() => _MiniCatalogAppState();
}

class _MiniCatalogAppState extends State<MiniCatalogApp> {
  // Tek root instance — uygulama ömrü boyunca paylaşılır.
  final CartModel _cart = CartModel();
  final FavoritesModel _favorites = FavoritesModel();
  final ThemeModeNotifier _themeMode = ThemeModeNotifier();

  @override
  void dispose() {
    _cart.dispose();
    _favorites.dispose();
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeMode,
      builder: (context, _) {
        return MaterialApp(
          title: 'Mini Catalog',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeMode.mode,
          home: MainShell(
            cart: _cart,
            favorites: _favorites,
            themeMode: _themeMode,
          ),
        );
      },
    );
  }
}
