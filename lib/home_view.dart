import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double startWeight = 110;
  double lastWeight = 80;
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    spots = [
      const FlSpot(0, 0),
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
      swapAnimationDuration: const Duration(milliseconds: 150),
      LineChartData(
        minX: 0,
        maxX: 8,
        minY: 0,
        maxY: 8,
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
            barWidth: 6,
            belowBarData: BarAreaData(
              show: true,
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
              show: true,
              getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                color: Colors.white,
                radius: 8,
                strokeColor: const Color(0xffF59841),
                strokeWidth: 3,
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
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.transparent,
                strokeWidth: 0.8,
              );
            }),
        lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 14,
              getTooltipItems: (value) {
                return value
                    .map((e) => LineTooltipItem(
                        "69.8 ",
                        children: [const TextSpan(text: 'kg')],
                        const TextStyle(fontSize: 14, color: Colors.white)))
                    .toList();
              },
              tooltipBgColor: Colors.grey,
            )),

        showingTooltipIndicators: [
          ShowingTooltipIndicators(
            [
              LineBarSpot(
                  LineChartBarData(
                      show: false,
                      color: Colors.white,
                      dotData: FlDotData(
                        show: true,
                      )),
                  1,
                  const FlSpot(6.5, 4.01))
            ],
          ),
        ],
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            drawBehindEverything: false,
            //axisNameWidget: const Text('SAFA'),
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 3,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = "Bugün";
                      break;
                    case 1:
                      text = "2";
                      break;
                    case 2:
                      text = "3";
                      break;
                    case 3:
                      text = "Şubat";
                      break;
                    case 4:
                      text = "5";
                      break;
                    case 5:
                      text = "6";
                      break;
                    case 6:
                      text = "Bitiş";
                      break;
                    default:
                      return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
