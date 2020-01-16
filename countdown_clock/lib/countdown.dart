import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A circular countdown.
class Countdown extends StatelessWidget {
  /// Creates a [Countdown].
  const Countdown({
    Key key,
    @required this.diameter,
    @required this.countdownTotal,
    @required this.countdownRemaining,
    this.countdownTotalColor = Colors.white30,
    this.countdownRemainingColor = Colors.white,
    this.countdownCurrentColor,
    this.gapFactor = 6,
    this.strokeWidth,
  })  : assert(diameter != null && diameter > 0.0),
        assert(countdownTotal != null && countdownTotal > 0.0),
        assert(countdownRemaining != null &&
            countdownRemaining >= 0.0 &&
            countdownRemaining <= countdownTotal),
        assert(gapFactor > 0.0),
        super(key: key);

  /// The outer diameter of the circular countdown widget.
  final double diameter;

  /// The total amount of units.
  final int countdownTotal;

  /// The amount of remaining units.
  final int countdownRemaining;

  /// The color to use when painting passed units.
  ///
  /// Defaults to [Colors.white30].
  final Color countdownTotalColor;

  /// The color to use when painting remaining units.
  ///
  /// Defaults to [Colors.white].
  final Color countdownRemainingColor;

  /// The color to use when painting the current unit.
  final Color countdownCurrentColor;

  /// The part of the circle representing gaps. (`1/gapFactor`)
  ///
  /// Example : `gapFactor: 2` means that 50% of the circle will be gaps.
  ///
  /// Defaults to [6].
  final double gapFactor;

  /// The thickness of the circle in logical pixels.
  ///
  /// Must be positive and less than [diameter/2].
  ///
  /// Default to [diameter/6] for proportion purpose.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final double paintStrokeWidth =
        (strokeWidth != null && strokeWidth > 0 && strokeWidth <= diameter / 2)
            ? strokeWidth
            : diameter / 6;
    return CustomPaint(
      painter: _CountdownPainter(
        countdownTotal: countdownTotal,
        countdownRemaining: countdownRemaining,
        countdownTotalColor: countdownTotalColor,
        countdownRemainingColor: countdownRemainingColor,
        countdownCurrentColor: countdownCurrentColor,
        gapFactor: gapFactor,
        strokeWidth: paintStrokeWidth,
      ),
      size: Size(
        diameter - paintStrokeWidth,
        diameter - paintStrokeWidth,
      ),
    );
  }
}

/// Painter that draws the circular countdown.
class _CountdownPainter extends CustomPainter {
  _CountdownPainter({
    @required this.countdownTotal,
    @required this.countdownRemaining,
    @required this.countdownTotalColor,
    @required this.countdownRemainingColor,
    @required this.strokeWidth,
    @required this.gapFactor,
    this.countdownCurrentColor,
  });

  final int countdownTotal;
  final int countdownRemaining;
  final Color countdownTotalColor;
  final Color countdownRemainingColor;
  final double gapFactor;
  final double strokeWidth;
  final Color countdownCurrentColor;

  Paint get totalPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = countdownTotalColor;

  Paint get remainingPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = countdownRemainingColor;

  Paint get currentPaint {
    if (countdownCurrentColor != null) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = countdownCurrentColor;
    } else {
      return null;
    }
  }

  double get emptyArcSize => 2 * math.pi / (gapFactor * countdownTotal);
  double get fullArcSize => 2 * math.pi / countdownTotal - emptyArcSize;
  double startAngle(int unit) =>
      -math.pi / 2 + unit * (emptyArcSize + fullArcSize) + emptyArcSize / 2;
  double getInnerRadius(double width) {
    final double _radius = width - 2 * strokeWidth;
    return (_radius > 0) ? _radius : 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    ui.Paint paint;
    for (int unit = 0; unit < countdownTotal; unit++) {
      if (currentPaint != null) {
        if (countdownTotal - unit < countdownRemaining) {
          paint = remainingPaint;
        } else if (countdownTotal - unit == countdownRemaining) {
          paint = currentPaint;
        } else {
          paint = totalPaint;
        }
      } else {
        if (countdownTotal - unit <= countdownRemaining) {
          paint = remainingPaint;
        } else {
          paint = totalPaint;
        }
      }
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        startAngle(unit),
        fullArcSize,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CountdownPainter oldDelegate) {
    return countdownTotal != oldDelegate.countdownTotal ||
        countdownRemaining != oldDelegate.countdownRemaining ||
        countdownTotalColor != oldDelegate.countdownTotalColor ||
        countdownRemainingColor != oldDelegate.countdownRemainingColor ||
        countdownCurrentColor != oldDelegate.countdownCurrentColor ||
        gapFactor != oldDelegate.gapFactor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
