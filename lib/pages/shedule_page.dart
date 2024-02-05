import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleTable extends StatefulWidget {
  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  Map<String, List<Map<String, dynamic>>> schedule = {};

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
      Map<String, dynamic> scheduleData = data['schedule'];
      Map<String, List<Map<String, dynamic>>> convertedSchedule = {};

      scheduleData.forEach((day, lessons) {
        convertedSchedule[day] = List<Map<String, dynamic>>.from(lessons);
      });

      setState(() {
        schedule = convertedSchedule;
      });
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var day in schedule.keys)
            DayTable(day: day, lessons: schedule[day] ?? []),
        ],
      ),
    );
  }
}

class DayTable extends StatelessWidget {
  final String day;
  final List<Map<String, dynamic>> lessons;

  const DayTable({super.key, required this.day, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day),
          DataTable(
            columnSpacing: 36.0,
            columns: const [
              DataColumn(
                label: Text(
                  '№',
                ),
              ),
              DataColumn(
                label: Text(
                  'Дисциплина',
                ),
              ),
              DataColumn(
                label: Text(
                  'Преподаватель',
                ),
              ),
              DataColumn(
                label: Text(
                  'Аудитория',
                ),
              ),
            ],
            rows: generateRows(),
          ),
        ],
      ),
    );
  }

  List<DataRow> generateRows() {
    List<DataRow> rows = [];
    lessons.forEach((lesson) {
      rows.add(DataRow(
        cells: [
          DataCell(Text(
            lesson['number'].toString(),
          )),
          DataCell(Text(
            lesson['discipline'] ?? '',
          )),
          DataCell(Text(
            lesson['lecturer'] ?? '',
          )),
          DataCell(Text(
            lesson['office'] ?? '',
          )),
        ],
      ));
    });
    return rows;
  }
}
