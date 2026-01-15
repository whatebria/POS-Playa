import '../../../sales/domain/enums/payment_method.dart';

class DailySale {
  final String id;
  final int totalClp;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;

  const DailySale({
    required this.id,
    required this.totalClp,
    required this.paymentMethod,
    required this.createdAt,
  });
}
