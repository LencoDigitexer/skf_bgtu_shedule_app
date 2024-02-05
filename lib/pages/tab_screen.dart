import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MaterialTabBarDemo extends StatefulWidget {
  const MaterialTabBarDemo({Key? key}) : super(key: key);

  @override
  _MaterialTabBarDemoState createState() => _MaterialTabBarDemoState();
}

class _MaterialTabBarDemoState extends State<MaterialTabBarDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<Map<String, dynamic>>> schedule;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    fetchSchedule();
  }

  void fetchSchedule() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/LencoDigitexer/schedule-api/main/skf-bgtu/vm11/schedule.json',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map<String, dynamic> && data.containsKey('schedule')) {
        final dynamic scheduleData = data['schedule'];

        if (scheduleData is Map<String, dynamic>) {
          setState(() {
            schedule = scheduleData.map<String, List<Map<String, dynamic>>>(
              (key, value) => MapEntry(
                key,
                List<Map<String, dynamic>>.from(value),
              ),
            );
          });
        } else {
          throw Exception('Invalid schedule data format');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ГРУППА ВМ-11'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDaysOfWeek(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (int index) {
            _tabController.animateTo(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Пары',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock),
              label: 'Расписание звонков',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    return ListView(
      children: [
        if (schedule.containsKey('monday'))
          _buildDataTable('Понедельник', schedule['monday']),
        if (schedule.containsKey('tuesday'))
          _buildDataTable('Вторник', schedule['tuesday']),
        if (schedule.containsKey('wednesday'))
          _buildDataTable('Среда', schedule['wednesday']),
        if (schedule.containsKey('thursday'))
          _buildDataTable('Четверг', schedule['thursday']),
        if (schedule.containsKey('friday'))
          _buildDataTable('Пятница', schedule['friday']),
      ],
    );
  }

  Widget _buildDataTable(String day, List<Map<String, dynamic>>? lessons) {
    return lessons != null && lessons.isNotEmpty
        ? DataTable(
            columns: const [
              DataColumn(label: Text('Пара')),
              DataColumn(label: Text('Дисциплина')),
              DataColumn(label: Text('Преподаватель')),
              DataColumn(label: Text('Кабинет')),
            ],
            rows: lessons
                .map(
                  (lesson) => DataRow(cells: [
                    DataCell(Text('${lesson['number']}')),
                    DataCell(Text('${lesson['discipline']}')),
                    DataCell(Text('${lesson['lecturer']}')),
                    DataCell(Text('${lesson['office']}')),
                  ]),
                )
                .toList(),
          )
        : Center(
            child: Text('Расписание для $day отсутствует'),
          );
  }
}
