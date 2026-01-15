import 'package:flutter/material.dart';
import '../../domain/entities/expense_category.dart';

class CategoryGrid extends StatelessWidget {
  final List<ExpenseCategory> categories;
  final void Function(ExpenseCategory) onSelected;
  final ExpenseCategory? selectedCategory;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onSelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) {
        final c = categories[i];
        final isSelected = selectedCategory?.id == c.id;
        return FilledButton(
          style: isSelected
              ? FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                )
              : null,
          onPressed: () => onSelected(c),
          child: Text(
            c.name,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
