import 'package:flutter/material.dart';

import '../../opening/presentation/opening_view.dart';
import '../../sales/presentation/sales_view.dart';
import '../../expenses/presentation/expenses_view.dart';
import '../../withdrawals/presentation/withdrawals_view.dart';
import '../../summary/presentation/summary_view.dart';
import '../../summary/presentation/history_view.dart';
import '../../closure/presentation/closure_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OpeningView(),
      const SalesView(),
      const ExpensesView(),
      const WithdrawalsView(),
      SummaryView(isActive: _selectedIndex == 4),
      HistoryView(isActive: _selectedIndex == 5),
      ClosureView(isActive: _selectedIndex == 6),
    ];

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              minWidth: 80,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.lock_open),
                  label: Text('Caja'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.point_of_sale),
                  label: Text('Ventas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long),
                  label: Text('Gastos'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.outbox),
                  label: Text('Retiros'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.summarize),
                  label: Text('Resumen'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('Historial'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.lock),
                  label: Text('Cierre'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
