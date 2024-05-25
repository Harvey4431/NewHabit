import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'habit_progress.dart';
class HabitItem extends StatefulWidget {
  final String name;
  final DateTime targetDate;
  final DateTime startDate;
  final double progress;
  final VoidCallback onDelete;


  HabitItem({
    required this.name,
    required this.targetDate,
    required this.startDate,
    required this.progress,
    required this.onDelete,

  });

  @override
  _HabitItemState createState() => _HabitItemState();
}

class _HabitItemState extends State<HabitItem> with AutomaticKeepAliveClientMixin {
  Timer? _timer;
  bool _isVisible = false;
  double _progress = 0.0;

  @override
  bool get wantKeepAlive => _isVisible;

  @override
  void initState() {
    super.initState();
    _checkVisibility();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkVisibility();
  }

  void _checkVisibility() {
    final isVisible = context.findRenderObject()?.paintBounds.isEmpty == false;
    if (isVisible != _isVisible) {
      setState(() {
        _isVisible = isVisible;
        if (_isVisible) {
          _startTimer();
        } else {
          _stopTimer();
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateProgress();
      setState(() {});
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _deleteHabit() async {
    widget.onDelete();
  }

  void _updateProgress() {
    final now = DateTime.now();
    final duration = now.difference(widget.startDate);
    final totalDuration = widget.targetDate.difference(widget.startDate);
    _progress = duration.inSeconds / totalDuration.inSeconds;
    _progress = _progress.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final now = DateTime.now();
    final duration = now.difference(widget.startDate);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return ListTile(
      leading: HabitProgress(progress: _progress),
      title: Text(widget.name),
      subtitle: Text('已坚持 $days 天 $hours 小时 $minutes 分钟 $seconds 秒'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: _deleteHabit,
      ),
    );
  }
}
