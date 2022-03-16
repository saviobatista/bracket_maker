// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:math';

import 'package:flutter/material.dart';

class BracketMaker extends CustomPainter {
  BracketMaker({required this.labels});
  final List<String> labels;
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF999999)
      ..style = PaintingStyle.fill;
    canvas.drawRect(const Offset(100, 100) & const Size(200, 150), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Quantidade de chaves sucessivas até o vencedor final
  /// Baseado no exponente da potenciacao de base 2
  int get steps {
    int step = 1;
    while (pow(2, step) < labels.length) {
      step++;
    }
    return step;
  }
}
