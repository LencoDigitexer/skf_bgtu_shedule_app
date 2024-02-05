import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleTable extends StatefulWidget {
  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  List<Map<String, dynamic>> schedule = [];

  @override
  void initState() {
    super.initState();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/LencoDigitexer/schedule-api/main/skf-bgtu/vm11/schedule.json'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<List<Map<String, dynamic>>> days = data['schedule']
          .values
          .map<List<Map<String, dynamic>>>(
              (day) => List<Map<String, dynamic>>.from(day))
          .toList();
      setState(() {
        schedule = days.expand((day) => day).toList();
      });
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('День')),
        DataColumn(label: Text('Номер пары')),
        DataColumn(label: Text('Дисциплина')),
        DataColumn(label: Text('Преподаватель')),
        DataColumn(label: Text('Аудитория')),
      ],
      rows: generateRows(),
    );
  }

  List<DataRow> generateRows() {
    List<DataRow> rows = [];
    schedule.forEach((lesson) {
      rows.add(DataRow(cells: [
        DataCell(Text(lesson['day'] ?? '')),
        DataCell(Text(lesson['number'].toString())),
        DataCell(Text(lesson['discipline'] ?? '')),
        DataCell(Text(lesson['lecturer'] ?? '')),
        DataCell(Text(lesson['office'] ?? '')),
      ]));
    });
    return rows;
  }
}
