import 'package:countdown_clock/time_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

/// A clock that focuses on the remaining time instead of the elapsed time.
class CountdownClock extends StatelessWidget {
  /// Creates a [CountdownClock].
  const CountdownClock(this.model);
  final ClockModel model;

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      color: isLightTheme ? Colors.white : Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double diameter = constraints.maxHeight - 10;
          final double stroke = diameter * 0.12;
          final double gap = constraints.maxHeight * 0.02;
          return Stack(
            children: <Widget>[
              TimeCountdown(
                model: model,
                countdownType: CountdownType.hour,
                diameter: diameter,
                strokeWidth: stroke,
              ),
              TimeCountdown(
                model: model,
                countdownType: CountdownType.minute,
                diameter: diameter - 2 * stroke - gap,
                strokeWidth: stroke,
              ),
              TimeCountdown(
                model: model,
                countdownType: CountdownType.second,
                diameter: diameter - 4 * stroke - 2 * gap,
                strokeWidth: (diameter - 4 * stroke - 2 * gap) / 2,
              ),
            ],
          );
        },
      ),
    );
  }
}
