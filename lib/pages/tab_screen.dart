import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoTabBarDemo extends StatelessWidget {
  const CupertinoTabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
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
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'ЧТ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'ПТ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'СБ',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return CupertinoTabView(builder: (context) {
                    return const CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: Text('ГРУППА ВМ-11'),
                        ),
                        child: Center(child: Text('ГРУППА ВМ-11')));
                  });
                case 1:
                  return CupertinoTabView(
                    builder: (context) {
                      return CustomScrollView(
                        slivers: <Widget>[
                          CupertinoSliverNavigationBar(
                            largeTitle: Text('Chats'),
                          ),
                        ],
                      );
                    },
                  );
                case 2:
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text('Bike Tab'),
                    ),
                    child: Center(child: _buildDataTable()),
                    backgroundColor: Colors.transparent,
                  );
                default:
                  return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Status')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('John')),
          DataCell(Text('Active')),
        ]),
        DataRow(cells: [
          DataCell(Text('2')),
          DataCell(Text('Jane')),
          DataCell(Text('Inactive')),
        ]),
        DataRow(cells: [
          DataCell(Text('3')),
          DataCell(Text('Bob')),
          DataCell(Text('Active')),
        ]),
      ],
    );
  }
}
