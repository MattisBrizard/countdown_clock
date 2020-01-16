import 'dart:async';

import 'package:countdown_clock/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Describes the time countdown types available.
enum CountdownType {
  /// Hour unit.
  hour,

  /// Minute unit.
  minute,

  /// Second unit.
  second,
}

/// A countdown that refreshes every `CountdownType` unit.
class TimeCountdown extends StatefulWidget {
  /// Creates a [TimeCountdown].
  const TimeCountdown({
    @required this.countdownType,
    @required this.diameter,
    @required this.strokeWidth,
    Key key,
  }) : super(key: key);

  /// The type of the countdown to show.
  ///
  /// Can be `hour`, `minute` or `second`
  final CountdownType countdownType;

  /// The diameter of the countdown.
  final double diameter;

  /// The strokewidth of the countdown.
  final double strokeWidth;

  @override
  _TimeCountdownState createState() => _TimeCountdownState();
}

class _TimeCountdownState extends State<TimeCountdown> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      switch (widget.countdownType) {
        case CountdownType.hour:
          _timer = Timer(
            const Duration(hours: 1) -
                Duration(minutes: _dateTime.minute) -
                Duration(seconds: _dateTime.second) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime,
          );
          break;
        case CountdownType.minute:
          _timer = Timer(
            const Duration(minutes: 1) -
                Duration(seconds: _dateTime.second) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime,
          );
          break;
        case CountdownType.second:
          _timer = Timer(
            const Duration(seconds: 1) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime,
          );
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    final int totalUnit =
        (widget.countdownType == CountdownType.hour) ? 24 : 60;
    int timeElapsed;
    double gapFactor;
    switch (widget.countdownType) {
      case CountdownType.hour:
        timeElapsed = _dateTime.hour;
        break;
      case CountdownType.minute:
        timeElapsed = _dateTime.minute;
        gapFactor = 2;
        break;
      case CountdownType.second:
        gapFactor = 1.2;
        timeElapsed = _dateTime.second;
        break;
      default:
    }
    return Center(
      child: Countdown(
        diameter: widget.diameter,
        gapFactor: gapFactor ?? 6,
        countdownTotal: totalUnit,
        countdownRemaining: totalUnit - timeElapsed,
        countdownCurrentColor:
            isLightTheme ? Colors.amber : const Color(0xFF05827D),
        strokeWidth: widget.strokeWidth,
        countdownRemainingColor: isLightTheme ? Colors.black : Colors.white,
        countdownTotalColor: isLightTheme ? Colors.black12 : Colors.white12,
      ),
    );
  }
}
