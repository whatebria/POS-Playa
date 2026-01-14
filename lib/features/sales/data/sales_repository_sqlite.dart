import 'package:playa/db/database.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/entities/product.dart';
import '../domain/entities/sale_item.dart';
import '../domain/enums/payment_method.dart';
import '../domain/repositories/sales_repository.dart';

class SalesRepositorySqlite implements SalesRepository {
  @override
  Future<List<Product>> getActiveProducts() async {
    final db = await AppDatabase.database;

    final rows = await db.query(
      'products',
      where: 'active = 1',
      orderBy: 'sort_order ASC, name ASC',
    );

    return rows
        .map(
          (r) => Product(
            id: r['id'] as String,
            name: r['name'] as String,
            priceClp: r['price'] as int,
          ),
        )
        .toList();
  }

  @override
  Future<void> registerSale({
    required String businessDay,
    required List<SaleItem> items,
    required PaymentMethod paymentMethod,
    required int totalClp,
    required String userId,
  }) async {
    final db = await AppDatabase.database;

    if (items.isEmpty) {
      throw Exception('La venta no tiene items');
    }

    await db.transaction((txn) async {
      try {
        final saleId = _uuid();

        // ---------------------------
        // 1. INSERT SALE
        // ---------------------------
        await txn.insert(
          'sales',
          {
            'id': saleId,
            'business_day': businessDay,
            'payment_method': _mapPayment(paymentMethod),
            'total': totalClp,
            'created_by_user_id': userId,
          },
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        // ---------------------------
        // 2. INSERT ITEMS
        // ---------------------------
        for (final item in items) {
          await txn.insert(
            'sale_items',
            {
              'id': _uuid(),
              'sale_id': saleId,
              'product_id': item.productId,
              'quantity': item.quantity,
              'unit_price': item.unitPriceClp,
              'subtotal': item.subtotalClp,
            },
            conflictAlgorithm: ConflictAlgorithm.abort,
          );
        }
      } on DatabaseException catch (e) {
        // Si falla algo → rollback automático
        throw Exception(e.toString());
      }
    });
  }

  // ================================
  // HELPERS
  // ================================

  String _mapPayment(PaymentMethod method) =>
      method == PaymentMethod.cash ? 'CASH' : 'TRANSFER';

  String _uuid() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
