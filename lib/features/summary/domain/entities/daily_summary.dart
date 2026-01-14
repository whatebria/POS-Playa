class DailySummary {
  final String businessDay;

  final int openingCash;

  final int salesCash;
  final int salesTransfer;

  final int expensesCash;
  final int expensesTransfer;

  final int withdrawalsCash;
  final int withdrawalsTransfer;

  final int cashExpected;

  const DailySummary({
    required this.businessDay,
    required this.openingCash,
    required this.salesCash,
    required this.salesTransfer,
    required this.expensesCash,
    required this.expensesTransfer,
    required this.withdrawalsCash,
    required this.withdrawalsTransfer,
    required this.cashExpected,
  });
}
