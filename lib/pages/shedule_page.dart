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
        convertedSchedule[translateDay(day)] =
            List<Map<String, dynamic>>.from(lessons);
      });

      setState(() {
        schedule = convertedSchedule;
      });
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  String translateDay(String day) {
    switch (day) {
      case 'monday':
        return 'Понедельник';
      case 'tuesday':
        return 'Вторник';
      case 'wednesday':
        return 'Среда';
      case 'thursday':
        return 'Четверг';
      case 'friday':
        return 'Пятница';
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Selection'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var day in schedule.keys)
                DayTable(day: day, lessons: schedule[day] ?? []),
            ],
          ),
        ));
  }
}

class DayTable extends StatelessWidget {
  final String day;
  final List<Map<String, dynamic>> lessons;

  const DayTable({Key? key, required this.day, required this.lessons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Измените на нужный вам цвет
            ),
          ),
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
