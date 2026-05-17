import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/favorites.dart';
import '../theme/app_theme.dart';
import '../theme/theme_mode_notifier.dart';

/// Profil ekranı — tema seçici + basit profil kartı.
class ProfileScreen extends StatelessWidget {
  final CartModel cart;
  final FavoritesModel favorites;
  final ThemeModeNotifier themeMode;

  const ProfileScreen({
    super.key,
    required this.cart,
    required this.favorites,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            _ProfileCard(),
            const SizedBox(height: 16),
            _StatsRow(cart: cart, favorites: favorites),
            const SizedBox(height: 24),
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.secondary,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 10),
            _ThemeSelector(themeMode: themeMode),
            const SizedBox(height: 24),
            Text(
              'Account',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.secondary,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 10),
            _SettingsTile(icon: Icons.notifications_outlined, label: 'Notifications'),
            _SettingsTile(icon: Icons.local_shipping_outlined, label: 'Orders & shipping'),
            _SettingsTile(icon: Icons.credit_card_outlined, label: 'Payment methods'),
            _SettingsTile(icon: Icons.help_outline_rounded, label: 'Help & support'),
            _SettingsTile(
              icon: Icons.logout_rounded,
              label: 'Sign out',
              destructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.divider.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
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
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emre Açanal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'emre@gmail.com',
                  style: TextStyle(fontSize: 12, color: c.secondary),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, size: 18, color: c.secondary),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final CartModel cart;
  final FavoritesModel favorites;
  const _StatsRow({required this.cart, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([cart, favorites]),
      builder: (context, _) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.favorite_rounded,
                value: favorites.count.toString(),
                label: 'Favorites',
                tinted: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_bag_outlined,
                value: cart.itemCount.toString(),
                label: 'In cart',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                icon: Icons.local_shipping_outlined,
                value: '0',
                label: 'Orders',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool tinted;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.tinted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: c.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.divider.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: tinted ? c.favorite : c.primary),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: c.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: c.secondary)),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeModeNotifier themeMode;
  const _ThemeSelector({required this.themeMode});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedBuilder(
      animation: themeMode,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _option(c, ThemeMode.system, Icons.brightness_auto_rounded, 'Auto'),
              _option(c, ThemeMode.light, Icons.light_mode_rounded, 'Light'),
              _option(c, ThemeMode.dark, Icons.dark_mode_rounded, 'Dark'),
            ],
          ),
        );
      },
    );
  }

  Widget _option(AppColors c, ThemeMode mode, IconData icon, String label) {
    final selected = themeMode.mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => themeMode.set(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? c.elevatedSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? c.primary : c.secondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? c.primary : c.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructive;
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final color = destructive ? c.favorite : c.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: c.cardBackground,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 22, color: c.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
