import 'package:countdown_clock/time_countdown.dart';
import 'package:flutter/material.dart';

/// A clock that focuses on the remaining time instead of the elapsed time.
///
/// Has a `light` and `dark` representation by switching the theme brightness.
class CountdownClock extends StatelessWidget {
  /// Creates a [CountdownClock].
  const CountdownClock();

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Container(
      color: isLightTheme ? Colors.white : Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double diameter = constraints.maxHeight;
            final double stroke = diameter * 0.12;
            final double gap = constraints.maxHeight * 0.040;

            return Stack(
              children: <Widget>[
                TimeCountdown(
                  countdownType: CountdownType.hour,
                  diameter: diameter,
                  strokeWidth: stroke,
                ),
                TimeCountdown(
                  countdownType: CountdownType.minute,
                  diameter: diameter - 2 * stroke - gap,
                  strokeWidth: stroke,
                ),
                TimeCountdown(
                  countdownType: CountdownType.second,
                  diameter: diameter - 4 * stroke - 2 * gap,
                  strokeWidth: (diameter - 4 * stroke - 2 * gap) / 2,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
