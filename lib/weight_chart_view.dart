import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightChartView extends StatefulWidget {
  const WeightChartView({super.key});

  @override
  State<WeightChartView> createState() => _WeightChartViewState();
}

class _WeightChartViewState extends State<WeightChartView> {
  double startWeight = 110;
  double lastWeight = 80;
  List<FlSpot> spots = [];
  double chartDotRadius = 4;
  double lineBarWith = 2;
  double chartDotStrokeWith = 1;
  bool barAreaDataShow = false;
  bool chartHorizontalLinesShow = false;
  bool showTitles = true;
  double lastYCordinat = 4.01;
  double lastXCordinat = 7;
  @override
  void initState() {
    super.initState();
    spots = [
      FlSpot.zero,
      const FlSpot(1, 1.5),
      const FlSpot(2, 2.2),
      const FlSpot(3, 2.6),
      const FlSpot(4, 2.8),
      const FlSpot(5, 3),
      const FlSpot(6, 3.3),
      FlSpot(lastXCordinat, lastYCordinat),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              height: 250,
              child: _lineChart(),
            ),
          ),
        ),
      ),
    );
  }

  LineChart _lineChart() {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 18,
        minY: 0,
        maxY: 12,
        //backgroundColor: Colors.black,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            shadow: const Shadow(color: Colors.pink, blurRadius: 1),
            gradient: const LinearGradient(
              colors: [
                Color(0xffF59841),
                Color(0xffEB6B50),
              ],
            ),
            barWidth: lineBarWith,
            belowBarData: BarAreaData(
              show: barAreaDataShow,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xffF59841).withOpacity(0.5),
                  const Color(0xffF59841).withOpacity(0.2),
                ],
              ),
            ),
            dotData: FlDotData(
              getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                color: const Color(0xffF59841),
                radius: chartDotRadius,
                strokeColor: const Color(0xffF59841),
                strokeWidth: chartDotStrokeWith,
              ),
              checkToShowDot: (spot, barData) {
                if (spot.y == 0 || spot.y == lastYCordinat) {
                  return true;
                }
                return false;
              },
            ),
          ),
        ],
        gridData: FlGridData(
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade300, strokeWidth: 1),
          horizontalInterval: 2,
          show: chartHorizontalLinesShow,
          drawVerticalLine: false,
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.transparent,
              strokeWidth: 0.8,
            );
          },
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 12,
            tooltipPadding: EdgeInsets.zero,
            getTooltipItems: (value) {
              return value
                  .map(
                    (e) => const LineTooltipItem(
                      '+12.3 ',
                      children: [TextSpan(text: 'kg')],
                      TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                  )
                  .toList();
            },
            getTooltipColor: (touchedSpot) => Colors.transparent,
          ),
        ),

        showingTooltipIndicators: [
          ShowingTooltipIndicators(
            [
              LineBarSpot(
                LineChartBarData(
                  show: false,
                  color: Colors.white,
                ),
                1,
                FlSpot(lastXCordinat, lastYCordinat),
              ),
            ],
          ),
        ],
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: showTitles,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: (value, meta) {
                var text = '';
                switch (value.toInt()) {
                  case 0:
                    text = '80.3 kg';
                  default:
                    return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 12, left: 18),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
