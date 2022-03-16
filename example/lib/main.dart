import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bracket Maker Tests'),
        ),
        body: CustomPaint(
          painter: BracketMaker(
            labels: [
              'Adamastor',
              'Pitágoras',
              'Adamastor',
              'Pitágoras',
            ],
          ),
        ),
      ),
    );
  }
}

class BracketMaker extends CustomPainter {
  BracketMaker({required this.labels});
  final List<String> labels;
  double width = 1000;
  double height = 600;
  final spacer = 30.0;
  final centerWidth = 100.0;
  final headerHeight = 100.0;
  @override
  void paint(Canvas canvas, Size size) {
    final header = Paint()
      ..color = const Color(0xFF999999)
      ..style = PaintingStyle.fill;
    final middle = Paint()
      ..color = const Color(0xFFAAAAAA)
      ..style = PaintingStyle.fill;
    final bg = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..style = PaintingStyle.fill;
    final rotulo = Paint()
      ..color = const Color(0xFF666666)
      ..style = PaintingStyle.stroke;
    final link = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke;
    canvas.drawRect(const Offset(0, 0) & Size(width, height), bg);
    canvas.drawRect(const Offset(0, 0) & Size(width, headerHeight), header);
    canvas.drawRect(
        Offset(width / 2 - centerWidth / 2, headerHeight + spacer) &
            Size(centerWidth, height - headerHeight - (spacer * 2)),
        middle);
    int rows = labels.length ~/ 2 + labels.length % 2;
    double largura =
        (width / 2 - centerWidth / 2 - spacer * steps - spacer) / steps;
    double altura = largura / 5;
    int base2rows = 1;
    while (base2rows < rows) {
      base2rows *= 2;
    }
    for (int step = 0; step < steps; step++) {
      //Define a quantidade de caixas a ser criada em mod2
      num caixas = base2rows / pow(2, step);
      double vspace = (height - headerHeight - altura * caixas) / caixas;
      if (step == 0) {
        /// A quantidade de chaves duplas (completas) pode ser calculada assim:
        /// pega a quantidade de labels a serem mostrados, retira a quantidade
        /// de lines que serão geradas no próximo, o resultado é o numero de
        /// caixas completas e o restante é o numero de caixas que ficarão só
        /// com um vinculo
        caixas = base2rows / pow(2, step + 1);
        num left = labels.length ~/ 2 + labels.length % 2;
        num right = labels.length ~/ 2;
        // num lFilled = caixas * 2 - left;
        // num rFilled = caixas * 2 - right;
        num lFilled = left - caixas;
        num rFilled = right - caixas;
        num lSpace = (height - headerHeight - altura) / left;
        num rSpace = (height - headerHeight - altura) / right;

        /// Set next step vertical spacing
        double nextBoxes = base2rows / pow(2, step + 1);

        double nextSpacer =
            (height - headerHeight - nextBoxes * altura) / nextBoxes;
        for (int i = 1; i <= labels.length; i++) {
          /// Current line
          int line = i ~/ 2 + i % 2;

          /// Label`s box plot
          double dx, dy;
          if (i % 2 == 1) {
            dx = spacer + (step * (spacer + largura));
            dy = headerHeight + lSpace * (line - 1) + lSpace / 2;
          } else {
            dx = width - spacer - ((step + 1) * (largura));
            dy = headerHeight + rSpace * (line - 1) + rSpace / 2;
          }
          canvas.drawRect(Offset(dx, dy) & Size(largura, altura), rotulo);

          /// Label plot
          ParagraphBuilder p = ParagraphBuilder(ParagraphStyle(
            fontSize: altura * 0.7,
            textAlign: TextAlign.center,
          ));
          p.addText(labels[i - 1]);
          Paragraph label = p.build();
          label.layout(ParagraphConstraints(width: largura));
          canvas.drawParagraph(label, Offset(dx, dy));

          /// Draw line to next box
          /// only if there are more steps to go
          if (step + 1 < steps) {
            /// Left box
            if (i % 2 == 1) {
              double x2 = dx + largura + spacer, y2;

              /// Filled boxes means there are two labels attached to that box
              /// otherwise only one for balancing
              ///
              if (line <= lFilled * 2) {
                /// Will be filled as regular
                y2 = headerHeight +
                    nextSpacer / 2 +
                    altura / 2 +
                    (((line + 1) ~/ 2) - 1) * (nextSpacer + altura);
              } else {
                y2 = headerHeight +
                    nextSpacer / 2 +
                    altura / 2 +
                    (line - lFilled - 1) * (nextSpacer + altura);
              }
              canvas.drawLine(
                  Offset(dx + largura, dy + altura / 2), Offset(x2, y2), link);

              /// RIGHT KEYS
            } else {
              double x2 = dx - spacer, y2;

              /// Filled boxes means there are two labels attached to that box
              /// otherwise only one for balancing
              ///
              if (line <= rFilled * 2) {
                /// Will be filled as regular
                y2 = headerHeight +
                    nextSpacer / 2 +
                    altura / 2 +
                    (((line + 1) ~/ 2) - 1) * (nextSpacer + altura);
              } else {
                y2 = headerHeight +
                    nextSpacer / 2 +
                    altura / 2 +
                    (line - rFilled - 1) * (nextSpacer + altura);
              }
              canvas.drawLine(
                  Offset(dx, dy + altura / 2), Offset(x2, y2), link);
            }
          }
        }
      } else {
        for (int i = 0; i < caixas; i++) {
          double dx1 = spacer + (step * (spacer + largura));
          double dx2 =
              width - spacer * step - spacer - ((step + 1) * (largura));
          double dy = headerHeight + (vspace + altura) * (i) + vspace / 2;
          canvas.drawRect(Offset(dx1, dy) & Size(largura, altura), rotulo);
          canvas.drawRect(Offset(dx2, dy) & Size(largura, altura), rotulo);
          //Draw line até a proxima
          if (step + 1 < steps) {
            double x1, x2, y1, y2;
            //Esquerda
            x1 = dx1 + largura;
            y1 = dy + altura / 2;
            x2 = x1 + spacer;
            if (i % 2 == 0) {
              y2 = y1 + vspace / 2;
            } else {
              y2 = y1 - vspace / 2;
            }
            canvas.drawLine(Offset(x1, y1), Offset(x2, y2), link);
            //Direita
            x1 = dx2;
            y1 = dy + altura / 2;
            x2 = x1 - spacer;
            if (i % 2 == 0) {
              y2 = y1 + vspace / 2;
            } else {
              y2 = y1 - vspace / 2;
            }
            canvas.drawLine(Offset(x1, y1), Offset(x2, y2), link);
          }
        }
      }
    }
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

  Size get labelSize {
    /// Calculo da largura baseado em
    /// tamanho disponivel pra calcular
    /// largura da tela -
    /// 100 para titulo -
    /// ( steps * spacer + 1 )
    /// depois pega tudo isto e divide pelos steps vai dar largura
    /// individual de cada caixa
    double largura = 0;

    /// Calculo da altura baseado em
    /// tamanho disponivel pra calcular
    /// altura da tela -
    /// espaco pra cabeçalho -
    /// ( pow(2,steps-1) * spacer )
    double altura = 0;
    return Size(largura, altura);
  }
}
