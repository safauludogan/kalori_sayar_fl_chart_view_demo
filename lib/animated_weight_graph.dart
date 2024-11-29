import 'dart:math';

import 'package:flutter/material.dart';

class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 1), // Animasyon süresini 5 saniyeye çıkardık
    );

    // Opaklık animasyonu
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.6,
          1,
          curve: Curves.easeIn,
        ), // Daha yavaş açılması için başlangıcı erkene çekildi
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 200),
            painter: WaveLinePainter(_controller, _opacityAnimation.value),
          );
        },
      ),
    );
  }
}

class WaveLinePainter extends CustomPainter {
  WaveLinePainter(this.animation, this.textOpacity) : super(repaint: animation);
  final Animation<double> animation;
  final double textOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    final start = Offset(50, size.height / 2);
    final end = Offset(size.width - 50, size.height / 2);

    // Gradyan renk
    const gradient = LinearGradient(
      colors: [
        Color(0xffF59841),
        Color(0xffEB6B50),
      ], // Başlangıç ve bitiş renkleri
    );

    final paint = Paint()
      ..shader = gradient
          .createShader(Rect.fromPoints(start, end)) // Gradyan uygulandı
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    const waveAmplitude = 14;
    const waveFrequency = .02;

    // Dalgalı çizgi oluşturma
    for (var t = 0; t <= progress * (end.dx - start.dx); t++) {
      final x = start.dx + t;
      final y = start.dy + waveAmplitude * -sin(waveFrequency * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // Başlangıç noktası yuvarlak ve yazı
    final startCirclePaintFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final startCirclePaintStroke = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    // Başlangıç noktasında yuvarlak çiz
    canvas.drawCircle(start, 8, startCirclePaintFill);
    canvas.drawCircle(start, 8, startCirclePaintStroke);

    // "Bugün" yazısını başlangıç noktasının altına ekliyoruz
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Bugün',
        style: TextStyle(
          color: Colors.grey.withOpacity(0.7), // Gri renkte
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      start.dx - textPainter.width / 2,
      start.dy + 12, // Başlangıç noktasının hemen altında
    );
    textPainter.paint(canvas, textOffset);

    // Animasyon bittiğinde bitiş yuvarlağını ve yazıyı çiz
    if (progress == 1.0) {
      final endCirclePaintFill = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final endCirclePaintStroke = Paint()
        ..color = Colors.orange
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;

      // Bitiş noktasında yuvarlak çiz
      canvas.drawCircle(end, 8, endCirclePaintFill);
      canvas.drawCircle(end, 8, endCirclePaintStroke);

      // Bitiş yazısı ve kutusu
      _drawTextBoxWithArrow(
        canvas,
        text: '80 KG',
        position: end,
        color: Colors.grey,
        offset: const Offset(
          0,
          -60,
        ), // Kutuyu yukarı kaydırma
        textOpacity: textOpacity,
        arrowDirection: ArrowDirection.down,
      );

      // Bitiş noktasının altına yazı ekle
      _drawTextBelow(
        canvas,
        text: 'Aralık', // Özelleştirilebilir metin
        position: end,
        offset: const Offset(0, 12), // Metni biraz alta kaydırma
      );
    }
  }

  void _drawTextBelow(
    Canvas canvas, {
    required String text,
    required Offset position,
    required Offset offset,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.grey, // Metin rengi
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      position.dx - textPainter.width / 2 + offset.dx,
      position.dy + offset.dy,
    );
    textPainter.paint(canvas, textOffset);
  }

  void _drawTextBoxWithArrow(
    Canvas canvas, {
    required String text,
    required Offset position,
    required Color color,
    required Offset offset,
    required double textOpacity,
    ArrowDirection arrowDirection =
        ArrowDirection.up, // Ok yönünü parametre olarak ekledik
  }) {
    const boxWidth = 65.0;
    const boxHeight = 35.0;

    final boxOffset = Offset(
      position.dx - boxWidth / 2,
      position.dy + offset.dy,
    );

    final balloonPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            boxOffset.dx,
            boxOffset.dy,
            boxWidth,
            boxHeight,
          ),
          const Radius.circular(24),
        ),
      );

    // Okun yönünü kontrol ederek çizim yapıyoruz
    if (arrowDirection == ArrowDirection.up) {
      balloonPath
        ..moveTo(position.dx - 5, position.dy + offset.dy)
        ..lineTo(position.dx, position.dy + offset.dy - 10)
        ..lineTo(position.dx + 5, position.dy + offset.dy)
        ..close();
    } else {
      balloonPath
        ..moveTo(position.dx - 5, position.dy + offset.dy + boxHeight)
        ..lineTo(position.dx, position.dy + offset.dy + boxHeight + 10)
        ..lineTo(position.dx + 5, position.dy + offset.dy + boxHeight)
        ..close();
    }

    final boxPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(balloonPath, boxPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withOpacity(textOpacity),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      boxOffset.dx + (boxWidth - textPainter.width) / 2,
      boxOffset.dy + (boxHeight - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum ArrowDirection { up, down }
