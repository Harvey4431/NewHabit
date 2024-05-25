import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'habit_page.dart';

class AddHabitPage extends StatefulWidget {
  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  String _habitName = '';
  DateTime _targetDate = DateTime.now().add(Duration(days: 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加新的习惯'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: '输入习惯名称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入习惯名称';
                  }
                  return null;
                },
                onChanged: (value) {
                  _habitName = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _targetDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _targetDate = date;
                    });
                  }
                },
                child: Text('选择目标日期: ${_targetDate.year}-${_targetDate.month}-${_targetDate.day}'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  _saveHabit();
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      final startDate = DateTime.now();
      await db.insert('habits', {
        'name': _habitName,
        'target_date': _targetDate.millisecondsSinceEpoch,
        'start_date': startDate.millisecondsSinceEpoch,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HabitPage()),
      );
    }
  }


}
