enum PaymentMethod { cash, transfer }

extension PaymentMethodX on PaymentMethod {
  String get label => this == PaymentMethod.cash ? 'Efectivo' : 'Transferencia';
}
