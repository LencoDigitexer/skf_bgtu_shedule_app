import 'package:flutter/material.dart';

class MaterialTabBarDemo extends StatefulWidget {
  const MaterialTabBarDemo({Key? key}) : super(key: key);

  @override
  _MaterialTabBarDemoState createState() => _MaterialTabBarDemoState();
}

class _MaterialTabBarDemoState extends State<MaterialTabBarDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
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
        _buildDataTable('Понедельник'),
        _buildDataTable('Вторник'),
        _buildDataTable('Среда'),
        _buildDataTable('Четверг'),
        _buildDataTable('Пятница'),
      ],
    );
  }

  Widget _buildDataTable(String day) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Пара')),
        DataColumn(label: Text('Дисциплина')),
        DataColumn(label: Text('Каб.')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('2\n10:10 - 11:40')),
          DataCell(Text('Физическая культура\nИванов И.В.')),
          DataCell(Text('14')),
        ]),
        DataRow(cells: [
          DataCell(Text('3\n11:50 - 13:20')),
          DataCell(Text('Математика\nПетров П.П.')),
          DataCell(Text('21')),
        ]),
        DataRow(cells: [
          DataCell(Text('4\n14:00 - 15:30')),
          DataCell(Text('Физика\nСидоров С.С.')),
          DataCell(Text('17')),
        ]),
        DataRow(cells: [
          DataCell(Text('5\n15:40 - 17:10')),
          DataCell(Text('Информатика\nКозлов К.К.')),
          DataCell(Text('23')),
        ]),
      ],
    );
  }
}
