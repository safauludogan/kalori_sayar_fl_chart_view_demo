import 'package:flutter/material.dart';

import 'home_view.dart';
import 'weight_chart_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: WeightChartView(),
    );
  }
}
