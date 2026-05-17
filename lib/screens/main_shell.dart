import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/favorites.dart';
import '../theme/app_theme.dart';
import '../theme/theme_mode_notifier.dart';
import 'discover_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

/// Bottom navigation bar'lı ana iskelet.
/// Discover · Favorites · Cart · Profile sekmelerini içerir.
class MainShell extends StatefulWidget {
  final CartModel cart;
  final FavoritesModel favorites;
  final ThemeModeNotifier themeMode;

  const MainShell({
    super.key,
    required this.cart,
    required this.favorites,
    required this.themeMode,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final pages = [
      DiscoverScreen(cart: widget.cart, favorites: widget.favorites),
      FavoritesScreen(cart: widget.cart, favorites: widget.favorites),
      CartScreen(cart: widget.cart),
      ProfileScreen(
        cart: widget.cart,
        favorites: widget.favorites,
        themeMode: widget.themeMode,
      ),
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _index,
        cart: widget.cart,
        favorites: widget.favorites,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final CartModel cart;
  final FavoritesModel favorites;
  final ValueChanged<int> onChanged;

  const _BottomNavBar({
    required this.currentIndex,
    required this.cart,
    required this.favorites,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: c.cardBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.divider.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([cart, favorites]),
            builder: (context, _) {
              return Row(
                children: [
                  _NavItem(
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore_rounded,
                    selected: currentIndex == 0,
                    onTap: () => onChanged(0),
                  ),
                  _NavItem(
                    icon: Icons.favorite_outline_rounded,
                    activeIcon: Icons.favorite_rounded,
                    selected: currentIndex == 1,
                    badge: favorites.count,
                    onTap: () => onChanged(1),
                  ),
                  _NavItem(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    selected: currentIndex == 2,
                    badge: cart.itemCount,
                    onTap: () => onChanged(2),
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    selected: currentIndex == 3,
                    onTap: () => onChanged(3),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? c.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    selected ? activeIcon : icon,
                    size: 22,
                    color: selected ? c.onPrimary : c.secondary,
                  ),
                  if (badge > 0)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: c.favorite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: c.cardBackground,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(minWidth: 16),
                        child: Text(
                          '$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
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
