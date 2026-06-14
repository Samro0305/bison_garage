import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../providers/revenue_chart_provider.dart';

class RevenueChart extends StatelessWidget {
  final List<RevenuePoint> data;

  const RevenueChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
  minY: 0,
                  gridData:
                      const FlGridData(
                    show: true,
                  ),

                  borderData:
                      FlBorderData(
                    show: false,
                  ),

                  titlesData:
                      FlTitlesData(
                   leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 70,
    getTitlesWidget: (value, meta) {
      if (value >= 1000) {
        return Text(
          '${(value / 1000).toStringAsFixed(0)}K',
          style: const TextStyle(fontSize: 12),
        );
      }

      return Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      );
    },
  ),
),

                    bottomTitles:
                        AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles:
                            true,
                        getTitlesWidget:
                            (
                          value,
                          meta,
                        ) {
                          if (value >= 0 &&
                              value <
                                  data.length) {
                            return Text(
                              data[value
                                      .toInt()]
                                  .month,
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,

                      spots:
                          List.generate(
                        data.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          data[index]
                              .revenue,
                        ),
                      ),

                      barWidth: 4,

                      dotData:
                          const FlDotData(
                        show: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}