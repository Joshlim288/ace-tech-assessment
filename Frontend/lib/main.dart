import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_connection.dart';
import 'package:responsive_grid/responsive_grid.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> groups = {};

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

  Future<void> getScoreboard() async {
    ApiConnection.getScoreboard((response) {
      setState(() {
        groups = jsonDecode(response);
      });
    });
  }

  Widget scoreboardGridView() {
    String currentGroup;
    List<dynamic> teams;
    return Center(
        child: ResponsiveGridList(
            shrinkWrap: true,
            desiredItemWidth: 650,
            children: groups.keys.map((i) {
              currentGroup = i;
              teams = groups[currentGroup] as List<dynamic>;
              return Card(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        child: Text(
                          'GROUP $currentGroup',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DataTable(
                        showBottomBorder: true,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Rank')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Points')),
                          DataColumn(label: Text('Goals Scored')),
                          DataColumn(label: Text('Alternate Points')),
                        ],
                        rows: <DataRow>[
                          for (int j = 0; j < teams.length; j++)
                            DataRow(cells: [
                              DataCell(Text((j + 1).toString())),
                              DataCell(Text(teams[j]['_id'].toString())),
                              DataCell(Text(teams[j]['points'].toString())),
                              DataCell(Text(teams[j]['goalsScored'].toString())),
                              DataCell(Text(teams[j]['altPoints'].toString())),
                            ])
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList()));
  }

  @override
  void initState() {
    super.initState();
    getScoreboard();
  }

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
                onPressed: () async {
                  await showInputDialog('Team Registration', 'Enter Teams:', Icons.group_add, true, ApiConnection.enterTeams);
                  getScoreboard();
                },
                child: const Text(
                  'Enter Teams',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(width: 10),
              TextButton(
                  onPressed: () async {
                    await showInputDialog('Match Results Entry', 'Enter Results:', Icons.scoreboard, true, ApiConnection.enterResults);
                    getScoreboard();
                  },
                  child: const Text('Enter Results', style: TextStyle(color: Colors.black))),
              Container(width: 10),
              TextButton(
                  onPressed: () async {
                    await showInputDialog('Clear Data', 'Delete all Team information from the system', Icons.warning_rounded, false, ApiConnection.clearData);
                    getScoreboard();
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
              if (groups.isNotEmpty) scoreboardGridView() else const Text('No data entered')
            ],
          ),
        ),
      ),
    );
  }
}
