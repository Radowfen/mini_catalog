import 'package:flutter/material.dart';
import '../data/product_repository.dart';
import '../theme/app_theme.dart';

/// Discover ekranı için yatay kaydırılabilir kategori chip listesi.
class CategoryChips extends StatelessWidget {
  final String selectedTag;
  final ValueChanged<String> onChanged;

  const CategoryChips({
    super.key,
    required this.selectedTag,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: ProductCategory.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = ProductCategory.all[i];
          final isSelected = cat.tag == selectedTag;
          return GestureDetector(
            onTap: () => onChanged(cat.tag),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? c.primary : c.divider,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    cat.icon,
                    size: 16,
                    color: isSelected ? c.onPrimary : c.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? c.onPrimary : c.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
