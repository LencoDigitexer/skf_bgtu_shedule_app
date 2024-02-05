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
          title: Text('Material Design Tabs Demo'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const Center(child: Text('ГРУППА ВМ-11')),
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text('Вторник'),
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      'https://example.com/image.jpg', // Замените на свою ссылку на изображение
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(child: _buildDataTable()),
            ),
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
              label: 'ПН',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'ВТ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'СР',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
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
          DataCell(Text('2\n10:10 - 11:40')),
          DataCell(Text('Физическая культура\nИванов И.В.')),
          DataCell(Text('14')),
        ]),
        DataRow(cells: [
          DataCell(Text('2\n10:10 - 11:40')),
          DataCell(Text('Физическая культура\nИванов И.В.')),
          DataCell(Text('14')),
        ]),
        DataRow(cells: [
          DataCell(Text('2\n10:10 - 11:40')),
          DataCell(Text('Физическая культура\nИванов И.В.')),
          DataCell(Text('14')),
        ]),
      ],
    );
  }
}
