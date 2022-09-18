import 'package:flutter/material.dart';
import 'package:frontend/api_connection.dart';

import 'input_alert_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GovTech Football Competition Scoreboard',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'GovTech Football'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Team {
  const Team(this.name, this.group, this.points, this.goalsScored, this.altPoints);
  final String name;
  final int group;
  final int points;
  final int goalsScored;
  final int altPoints;
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, List<Team>> groups = {};

  Future<void> showInputDialog(String title, String prompt, IconData icon, isInput, Function submitFunction) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => InputDialog(
        title: title,
        prompt: prompt,
        icon: icon,
        isInput: isInput,
        submitFunction: submitFunction,
      ),
    );
  }

  showAlertDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  showInputDialog('Team Registration', 'Enter Teams:', Icons.group_add, true, ApiConnection.enterTeams);
                },
                child: const Text(
                  'Enter Teams',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(width: 10),
              TextButton(onPressed: () {}, child: const Text('Enter Results', style: TextStyle(color: Colors.black))),
              Container(width: 10),
              TextButton(
                  onPressed: () {
                    showInputDialog('Clear Data', 'Delete all Team information from the system', Icons.warning_rounded, false, ApiConnection.clearData);
                  },
                  child: const Text('Clear Data', style: TextStyle(color: Colors.black))),
              Container(width: 50),
            ],
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              const Text(
                'Scoreboard',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: '',
                ),
              ),
              Container(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'GROUP 1',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Rank'),
                          ),
                          DataColumn(
                            label: Text('Name'),
                          ),
                          DataColumn(
                            label: Text('Points'),
                          ),
                          DataColumn(
                            label: Text('Goals Scored'),
                          ),
                          DataColumn(
                            label: Text('Alternate Points'),
                          ),
                        ],
                        rows: const <DataRow>[
                          DataRow(cells: [
                            DataCell(Text('1')),
                            DataCell(Text('Arshik')),
                            DataCell(Text('5644645')),
                            DataCell(Text('3')),
                            DataCell(Text('265')),
                          ])
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
