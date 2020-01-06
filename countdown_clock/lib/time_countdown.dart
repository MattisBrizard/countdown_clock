import 'dart:async';

import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

/// Describes the time countdown types available.
enum CountdownType { hour, minute, second }

/// A countdown that refreshes every `CountdownType` unit.
class TimeCountdown extends StatefulWidget {
  /// Creates a [TimeCountdown].
  const TimeCountdown({
    @required this.model,
    @required this.countdownType,
    @required this.diameter,
    @required this.strokeWidth,
    Key key,
  }) : super(key: key);

  /// The clock model to use.
  final ClockModel model;

  /// The type of the countdown to show.
  ///
  /// Can be `hour`, `minute` or `second`
  final CountdownType countdownType;

  /// The diameter of the countdown.
  final double diameter;

  /// The strokewidth of the countdown.
  final double strokeWidth;

  @override
  TimeCountdownState createState() => TimeCountdownState();
}

class TimeCountdownState extends State<TimeCountdown> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(TimeCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      switch (widget.countdownType) {
        case CountdownType.hour:
          _timer = Timer(
            Duration(hours: 1) -
                Duration(minutes: _dateTime.minute) -
                Duration(seconds: _dateTime.second) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime,
          );
          break;
        case CountdownType.minute:
          _timer = Timer(
            Duration(minutes: 1) -
                Duration(seconds: _dateTime.second) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime,
          );
          break;
        case CountdownType.second:
          _timer = Timer(
            Duration(seconds: 1) -
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
    switch (widget.countdownType) {
      case (CountdownType.hour):
        timeElapsed = _dateTime.hour;
        break;
      case (CountdownType.minute):
        timeElapsed = _dateTime.minute;
        break;
      case (CountdownType.second):
        timeElapsed = _dateTime.second;
        break;
      default:
    }
    return Center(
      child: CircularCountdown(
        diameter: widget.diameter,
        countdownTotal: totalUnit,
        countdownRemaining: totalUnit - timeElapsed,
        countdownCurrentColor: isLightTheme ? Colors.amber : Colors.redAccent,
        strokeWidth: widget.strokeWidth,
        countdownRemainingColor: isLightTheme ? Colors.black : Colors.white,
        countdownTotalColor: isLightTheme ? Colors.black : Colors.white12,
      ),
    );
  }
}
