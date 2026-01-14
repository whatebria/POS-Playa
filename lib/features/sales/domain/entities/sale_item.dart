class SaleItem {
  final String productId;
  final int quantity;
  final int unitPriceClp;

  const SaleItem({
    required this.productId,
    required this.quantity,
    required this.unitPriceClp,
  });

  int get subtotalClp => quantity * unitPriceClp;
}
