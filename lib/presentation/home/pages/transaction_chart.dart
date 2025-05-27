import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionsPieChart extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TransactionsPieChart({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    final data = _aggregate(transactions);
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: _buildSections(data),
          sectionsSpace: 3,
          centerSpaceRadius: 60,
          borderData: FlBorderData(show: false),
          titleSunbeamLayout: false,
        ),
      ),
    );
  }

  Map<String, double> _aggregate(List<TransactionEntity> list) => {
    for (var t in list)
      transactionTypeToString(t.type): (list
          .where((e) => e.type == t.type)
          .fold(0.0, (a, b) => a + b.amount)),
  };

  List<PieChartSectionData> _buildSections(Map<String, double> data) =>
      data.entries.map((e) {
        return PieChartSectionData(
          color:
              [
                Colors.green.shade200,
                Colors.blue.shade200,
                Colors.orange.shade200,
                Colors.purple.shade200,
                Colors.red.shade200,
              ][data.keys.toList().indexOf(e.key) % 5],
          value: e.value,
          title: e.key,
          radius: 30,
          titleStyle: TextStyle(fontSize: 14, color: Colors.green.shade900),
        );
      }).toList();
}
