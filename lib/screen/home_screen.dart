import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:seong_flutter/screen/widget/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDateTime;
  List<List<String>> tableData = [];
  double dataTableWidth = 902;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _body(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        'Battery Monitoring',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: dataTableWidth + 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  inputField(context),
                  SizedBox(width: 20),
                  selectTime(context),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      _button(() {
                        _runPythonScript;
                      }, 'Download'),
                      SizedBox(width: 10),
                      _button(() {
                        _anotherFunction;
                      }, 'Algorithm'),
                      SizedBox(width: 10),

                      _button(() {
                        _saveOpensearch;
                      }, 'Opensearch'),
                    ],
                  )

                ],
              ),
              SizedBox(height: 40),
              _buildDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectTime(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 3,
        //     blurRadius: 7,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time', style: TextStyle(fontSize: 18)),
          SizedBox(
            width: 300,
            child: selectedDateTime != null
                ? Text(
                    DateFormat('yyyy - MM - dd  HH:mm')
                        .format(selectedDateTime!),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                : SizedBox(),
          ),
          const SizedBox(height: 10),
          _button(
            () {
              _selectDateTime(context);
            },
            'Calendar',
          ),
        ],
      ),
    );
  }

  Widget _button(VoidCallback callback, String title) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey.shade200,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget inputField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            textController: textFieldController1,
            hintText: "input 0~100 integer",
            label: 'criteria level',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final int? number = int.tryParse(value);
              if (number == null || number < 0 || number > 100) {
                return 'Enter a number between 0 and 100';
              }
              return null;
            },
          ),
          CustomTextField(
            textController: textFieldController2,
            hintText: "input 0~24 integer",
            label: 'criteria time',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final int? number = int.tryParse(value);
              if (number == null || number < 1 || number > 24) {
                return 'Enter a number between 1 and 24';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            onPressed(context);
          }
        },
        child: Text(label),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      width: dataTableWidth,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('watch s/n')),
          DataColumn(label: Text('date')),
          DataColumn(label: Text('time')),
          DataColumn(label: Text('dis_time')),
          DataColumn(label: Text('lev')),
          DataColumn(label: Text('pass/fail')),
          DataColumn(label: Text('cri_lev')),
          DataColumn(label: Text('cri_time')),
        ],
        rows: tableData.map((rowData) {
          return DataRow(
              cells: rowData.map((data) => DataCell(Text(data))).toList());
        }).toList(),
      ),
    );
  }

  void _runPythonScript(BuildContext context) async {
    String downPythonScriptPath = 'app/data_down.py';
    _showSnackbar(context, 'Running Python script...');
    ProcessResult result = await Process.run('python', [downPythonScriptPath]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    String errorMessage = await _readErrorLog();
    _showErrorDialog(context, 'Error', errorMessage);
    _showSnackbar(context, 'Python script executed.');
  }

  void _saveOpensearch(BuildContext context) async {
    String saveOpensearch = 'app/opensearch.py';
    _showSnackbar(context, 'Running Opensearch script...');
    ProcessResult result = await Process.run('python', [saveOpensearch]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    _showSnackbar(context, 'Opensearch script executed.');
  }

  void _anotherFunction(BuildContext context) async {
    String alPythonScriptPath = 'app/Algorithm.py';
    _showSnackbar(context, 'Running Algorithm script...');
    ProcessResult result = await Process.run('python', [alPythonScriptPath]);
    print('\n${result.stdout}');
    await _loadDataFromFile();
    setState(() {});
    _showSnackbar(context, 'Algorithm script executed.');
    String errorMessage = await _readError_al();
    _showErrorDialog(context, 'Error', errorMessage);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime date = DateTime.now();
    TimeOfDay time = TimeOfDay.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: time,
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        String formattedDateTime =
            DateFormat('yyyyMMdd HH').format(pickedDateTime);
        print('Selected DateTime: $formattedDateTime');
        await _saveToFile(formattedDateTime);

        setState(() {
          selectedDateTime = pickedDateTime;
        });
        await _saveToFile(
            '${textFieldController1.text} ${textFieldController2.text}',
            append: true);
      }
    }
  }

  Future<void> _saveToFile(String data, {bool append = false}) async {
    final directory = Directory.current;
    final path = directory.path;
    final csvDirectory = Directory('$path/csv_files');

    if (!csvDirectory.existsSync()) {
      csvDirectory.createSync();
    }

    final file = File('${csvDirectory.path}/data.csv');
    await file.writeAsString('$data\n',
        mode: append ? FileMode.append : FileMode.write, flush: true);
    print('Data saved to ${file.path}');
  }

  Future<void> _loadDataFromFile() async {
    final directory = Directory.current;
    final path = directory.path;
    final csvDirectory = Directory('$path/csv_files');

    if (!csvDirectory.existsSync()) {
      csvDirectory.createSync();
    }

    final file = File('${csvDirectory.path}/result.csv');
    print(file);

    if (file.existsSync()) {
      List<String> lines = await file.readAsLines(encoding: utf8);
      List<List<String>> loadedData = lines.map((line) {
        List<String> rowData = line.trim().split(RegExp(r'\s+'));
        return rowData;
      }).toList();

      int maxCells = 8;
      loadedData.forEach((rowData) {
        while (rowData.length < maxCells) {
          rowData.add('');
        }
      });

      setState(() {
        tableData = loadedData;
      });
    }
  }

  Future<String> _readErrorLog() async {
    final directory = Directory.current;
    final path = directory.path;
    final errorLogFile = File('$path/error_data/error_log.txt');

    if (errorLogFile.existsSync()) {
      try {
        return await errorLogFile.readAsString(encoding: utf8);
      } catch (e) {
        return 'Failed to read error log: $e';
      }
    } else {
      return 'No error log found.';
    }
  }

  Future<String> _readError_al() async {
    final directory = Directory.current;
    final path = directory.path;
    final errorLogFile = File('$path/error_data/error_algorithm.txt');

    if (errorLogFile.existsSync()) {
      try {
        return await errorLogFile.readAsString(encoding: utf8);
      } catch (e) {
        return 'Failed to read error log: $e';
      }
    } else {
      return 'No error algorithm found.';
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
