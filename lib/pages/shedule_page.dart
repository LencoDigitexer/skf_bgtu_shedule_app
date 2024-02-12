import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'group_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleTable extends StatefulWidget {
  final String groupSelect;

  ScheduleTable({required this.groupSelect});

  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  Map<String, List<Map<String, dynamic>>> schedule = {};
  String groupName = ''; // Строка для хранения названия группы

  @override
  void initState() {
    super.initState();
    fetchGroups(); // Загрузка данных о группах при инициализации
    fetchSchedule();
  }

  Future<void> fetchGroups() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/LencoDigitexer/schedule-api/main/skf-bgtu/groups.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final groups = data['groups'];
      final selectedGroup = groups.firstWhere(
          (group) => group['name'] == widget.groupSelect,
          orElse: () => {'description': 'Твоя группа'});
      setState(() {
        groupName = selectedGroup['description'];
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  Future<void> fetchSchedule() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/LencoDigitexer/schedule-api/main/skf-bgtu/${widget.groupSelect}/schedule.json'));
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
        return 'ПН';
      case 'tuesday':
        return 'ВТ';
      case 'wednesday':
        return 'СР';
      case 'thursday':
        return 'ЧТ';
      case 'friday':
        return 'ПТ';
      case 'saturday':
        return 'СБ';
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: schedule.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupName), // Название группы
          leading: BackButton(
            onPressed: () {
              clearCredentials();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GroupSelectionScreen()),
              );
            },
          ),
        ),
        body: Center(
          child: TabBarView(
            children: [
              for (var day in schedule.keys)
                DayTable(day: day, lessons: schedule[day] ?? []),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          isScrollable: false,
          tabs: [
            for (var day in schedule.keys)
              Tab(
                text: day,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('group_select');
  }
}

class DayTable extends StatelessWidget {
  final String day;
  final List<Map<String, dynamic>> lessons;

  const DayTable({Key? key, required this.day, required this.lessons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Wrap the Column with Center widget
      child: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            DataTable(
              dataRowHeight: 60.0,
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
