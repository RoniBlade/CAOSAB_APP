import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supply_sync_app/screens/title_widget.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Align(
            alignment: Alignment.center, // Центрируем заголовок
            child: TitleWidget(),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Пунктирная рамка вокруг сканера
                CustomPaint(
                  size: const Size(275, 275),
                  painter: DashedBorderPainter(),
                ),
                // Сканер внутри рамки
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (capture) {
                        for (final barcode in capture.barcodes) {
                          final String? code = barcode.rawValue;
                          if (code != null) {
                            print('QR Code: $code');
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Разместите код внутри рамки',
            style: TextStyle(
              fontFamily: 'Jura',
              fontSize: 18,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintSolid = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Закругленные концы для цельных линий

    final paintDashed = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const radius = 20.0; // Радиус углов
    const dashWidth = 10.0;
    const dashSpace = 5.0;

    // Верхний правый угол (цельная линия с закруглением)
    final pathTopRight = Path()
      ..moveTo(size.width - (radius + size.height * 0.2), 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, size.height * 0.2);
    canvas.drawPath(pathTopRight, paintSolid);

    // Нижний левый угол (цельная линия с закруглением)
    final pathBottomLeft = Path()
      ..moveTo(0, size.height - (radius + size.height * 0.2))
      ..lineTo(0, size.height - radius)
      ..arcToPoint(
        Offset(radius, size.height),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width * 0.2, size.height);
    canvas.drawPath(pathBottomLeft, paintSolid);

    // Верхний левый угол (пунктирная линия)
    final pathTopLeft = Path()
      ..moveTo(0, radius + size.height * 0.1)
      ..lineTo(0, radius)
      ..arcToPoint(
        Offset(radius, 0),
        radius: const Radius.circular(radius),
      )
      ..lineTo(radius + size.height * 0.1 + 3, 0);
    _drawDashedPath(canvas, pathTopLeft, dashWidth, dashSpace, paintDashed);

    // Нижний правый угол (пунктирная линия)
    final pathBottomRight = Path()
      ..moveTo(size.width - ((size.width * 0.1) + radius), size.height)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - radius),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - ((size.height * 0.1) + radius + 3));
    _drawDashedPath(canvas, pathBottomRight, dashWidth, dashSpace, paintDashed);
  }

  // Метод для рисования пунктирного пути
  void _drawDashedPath(Canvas canvas, Path path, double dashWidth, double dashSpace, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, nextDistance),
          paint,
        );
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
