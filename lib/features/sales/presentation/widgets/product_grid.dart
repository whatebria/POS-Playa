import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../../shared/widgets/money_text.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onSelected;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final product = products[i];

        return FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          onPressed: () => onSelected(product),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              MoneyText(
                amountIntClp: product.priceClp,
                size: 20,
                emphasis: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
