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
              icon: Icon(CupertinoIcons.car),
              label: 'Car',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bus),
              label: 'Transit',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.battery_0),
              label: 'Bike',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text('Car Tab'),
                    ),
                    child: Center(
                      child: _buildDataTable(),
                    ),
                  );
                case 1:
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text('Transit Tab'),
                    ),
                    child: Center(
                      child: _buildDataTable(),
                    ),
                  );
                case 2:
                  return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text('Bike Tab'),
                    ),
                    child: Center(
                      child: _buildDataTable(),
                    ),
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
