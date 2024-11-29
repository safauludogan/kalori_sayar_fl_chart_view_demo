import 'package:flutter/material.dart';
import 'package:kalori_sayar_line_chart_result_screen_demo/animated_weight_graph.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: WaveAnimation(),
    );
  }
}
