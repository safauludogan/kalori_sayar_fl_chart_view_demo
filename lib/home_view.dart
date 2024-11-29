import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double startWeight = 110;
  double lastWeight = 80;
  List<FlSpot> spots = [];

  /// Başlangıç ve bitiş noktalarının boyutu
  double chartDotRadius = 8;

  /// Bar çizgisinin kalınlığı
  double lineBarWith = 6;

  /// Başlangıç ve bitiş dairelerinin kalınlığı
  double chartDotStrokeWith = 6;

  @override
  void initState() {
    super.initState();
    spots = [
      FlSpot.zero,
      const FlSpot(1, 1),
      const FlSpot(2, 2.3),
      const FlSpot(3, 3),
      const FlSpot(4, 3.1),
      const FlSpot(5, 3.2),
      const FlSpot(6, 3.9),
      const FlSpot(6.5, 4.01),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 250,
            child: _lineChart(),
          ),
        ),
      ),
    );
  }

  LineChart _lineChart() {
    return LineChart(
      duration: const Duration(milliseconds: 1000),
      LineChartData(
        minX: 0,
        maxX: 7.5,
        minY: 0,
        maxY: 8,
        //backgroundColor: Colors.black,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            shadow: const Shadow(color: Colors.pink),
            gradient: const LinearGradient(
              colors: [
                Color(0xffF59841),
                Color(0xffEB6B50),
              ],
            ),
            barWidth: lineBarWith,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xffF59841).withOpacity(0.5),
                  const Color(0xffF59841).withOpacity(0.05),
                ],
              ),
            ),
            dotData: FlDotData(
              getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                color: Colors.red,
                radius: chartDotRadius,
                strokeColor: const Color(0xffF59841),
                strokeWidth: chartDotStrokeWith,
              ),
              checkToShowDot: (spot, barData) {
                if (spot.y == 0 || spot.y == 4.01) {
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
            tooltipRoundedRadius: 14,
            getTooltipItems: (value) {
              return value
                  .map(
                    (e) => const LineTooltipItem(
                      '69.8 ',
                      children: [TextSpan(text: 'kg')],
                      TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  )
                  .toList();
            },
            getTooltipColor: (touchedSpot) => Colors.grey,
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
                const FlSpot(6.5, 4.01),
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
            drawBelowEverything: false,
            //axisNameWidget: const Text('SAFA'),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: (value, meta) {
                var text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Bugün';
                  case 1:
                    text = '2';
                  case 2:
                    text = '3';
                  case 3:
                    text = 'Şubat';
                  case 4:
                    text = '5';
                  case 5:
                    text = '6';
                  case 6:
                    text = 'Bitiş';
                  default:
                    return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12),
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
