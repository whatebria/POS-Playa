import 'package:flutter/material.dart';
import '../../domain/entities/expense_category.dart';

class CategoryGrid extends StatelessWidget {
  final List<ExpenseCategory> categories;
  final void Function(ExpenseCategory) onSelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onSelected,
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
        return FilledButton(
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
