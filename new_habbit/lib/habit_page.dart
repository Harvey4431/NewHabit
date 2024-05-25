import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_habit_page.dart';
import 'database_helper.dart';
import 'habit_item.dart';

class HabitPage extends StatefulWidget {
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  List<Map<String, dynamic>> _habits = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  Future<void> _loadHabits() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> habits = await db.query('habits');
    setState(() {
      _habits = habits;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的习惯'),
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          final targetDate = DateTime.fromMillisecondsSinceEpoch(habit['target_date'] as int);
          final startDate = DateTime.fromMillisecondsSinceEpoch(habit['start_date'] as int);
          final now = DateTime.now();
          final progress = (now.difference(startDate).inSeconds) / (targetDate.difference(startDate).inSeconds);

          return HabitItem(
            name: habit['name'],
            targetDate: targetDate,
            startDate: startDate,
            progress: progress.clamp(0.0, 1.0),
            onDelete: () => _deleteHabit(habit['id'] as int),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: Icon(Icons.add),
      ),
    );
  }


  Future<void> _addHabit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddHabitPage()),
    );
    // 刷新 HabitPage
    setState(() {
      _loadHabits();
    });
  }

  Future<void> _deleteHabit(int id) async {
    await DatabaseHelper().deleteHabit(id);
    _loadHabits();
  }

}
