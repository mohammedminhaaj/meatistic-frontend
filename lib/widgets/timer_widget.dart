import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {super.key,
      required this.seconds,
      required this.onTimerEnd,
      this.prefixText});

  final int seconds;
  final void Function() onTimerEnd;
  final String? prefixText;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds--;
        } else {
          widget.onTimerEnd();
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefixText} ${_currentSeconds}s',
      style: const TextStyle(fontSize: 14),
    );
  }
}
