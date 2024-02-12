import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'tab_screen.dart';
import 'shedule_page.dart';

class GroupSelectionScreen extends StatefulWidget {
  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  final TextEditingController _groupController = TextEditingController();
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    final response = await http.get(
      Uri.parse(
          'https://raw.githubusercontent.com/LencoDigitexer/schedule-api/main/skf-bgtu/groups.json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> groupsData = data['groups'];

      setState(() {
        groups = groupsData.map((group) => Group.fromJson(group)).toList();
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание пар СКФ БГТУ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Выбери свою группу:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MaterialTabBarDemo()),
                );
              },
              child: Text("Test"),
            ),
            if (groups.isEmpty)
              CircularProgressIndicator()
            else
              Column(
                children: groups
                    .map(
                      (group) => ElevatedButton(
                        onPressed: () async {
                          // Handle button press, you can navigate to the next screen or perform any other action

                          _groupController.text = group.name;
                          await saveCredentials();
                          print('Selected group: ${_groupController.text}');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScheduleTable(
                                    groupSelect: _groupController.text)),
                          );
                        },
                        child: Text(group.description),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('group_select', _groupController.text);
  }
}

class Group {
  final String name;
  final String description;

  Group({required this.name, required this.description});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'],
      description: json['description'],
    );
  }
}
