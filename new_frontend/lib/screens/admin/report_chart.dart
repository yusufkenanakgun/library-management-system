import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsBarChart extends StatelessWidget {
  final int books;
  final int users;
  final int borrows;
  final int favorites;

  const ReportsBarChart({
    super.key,
    required this.books,
    required this.users,
    required this.borrows,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            [books, users, borrows, favorites].reduce((a, b) => a > b ? a : b) *
            1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, _) {
                final titles = ['Books', 'Users', 'Borrows', 'Favorites'];
                return Text(titles[value.toInt()]);
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: books.toDouble(), color: Colors.blue),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: users.toDouble(), color: Colors.green),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: borrows.toDouble(), color: Colors.orange),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: favorites.toDouble(), color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
