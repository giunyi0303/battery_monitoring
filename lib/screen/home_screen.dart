import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:seong_flutter/screen/home_view_model.dart';
import 'package:seong_flutter/screen/widget/custom_text_field.dart';

import 'widget/custom_widget.dart';

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
  bool isRun = false;

  //ViewModel
  Function()? listener;
  final HomeViewModel vm = HomeViewModel();

  // initState는 build될 시 가장 먼저 호출되는 함수, 한번만 실행됌.
  // 보통 최초 실행 시 초기화가 필요한 변수들을 선언함.
  @override
  void initState() {
    // viewModel Listener 추가
    listener = () {
      if (mounted) {
        setState(() {});
      }
    };
    vm.addListener(listener!);
    super.initState();
  }

  // 해당 화면이 종료 될 경우 호출 되는 함수, 즉 HomeScreen이 종료 될 때 dispose가 호출됨.
  // 메모리 관리를 위해 Listener를 remove 해주어야한다.
  @override
  void dispose() {
    vm.removeListener(listener!);
    listener = null;
    super.dispose();
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
      title: const Text(
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
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 제일 위로 붙도록 정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputField(context),
                  selectTime(context),
                  Column(
                    children: [
                      Row(
                        children: [
                          _button(() {
                            setState(() {
                              runPythonScript(context);
                            });
                          }, 'Download'),
                          SizedBox(width: 10),
                          _button(() {
                            anotherFunction(context);
                          }, 'Algorithm'),
                          SizedBox(width: 10),
                          _button(() {
                            saveOpensearch(context);
                          }, 'Opensearch'),
                        ],
                      ),
                      const SizedBox(height: 40),
                      if (isRun) const CircularProgressIndicator(),
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
    const TextStyle textStyle =
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: selectedDateTime != null
                  ? Text(
                      DateFormat('yyyy - MM - dd  HH:mm')
                          .format(selectedDateTime!),
                      style: textStyle,
                    )
                  : Text("날짜를 선택해 주세요.", style: textStyle),
            ),
            const SizedBox(height: 20),
            _button(
              () {
                _selectDateTime(context);
              },
              'Calendar',
            ),
          ],
        ),
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
          style: const TextStyle(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Future<void> runPythonScript(BuildContext context) async {
    String downPythonScriptPath = 'app/data_down.py';
    CustomWidget().showSnackBar(context, 'Running Python script...');
    ProcessResult result = await Process.run('python', [downPythonScriptPath]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    String errorMessage = await _readErrorLog();
    CustomWidget().showErrorDialog(context, 'Error', errorMessage);
    CustomWidget().showSnackBar(context, 'Python script executed.');
  }

  Future<void> saveOpensearch(BuildContext context) async {
    String saveOpensearch = 'app/opensearch.py';
    CustomWidget().showSnackBar(context, 'Running Opensearch script...');
    ProcessResult result = await Process.run('python', [saveOpensearch]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    CustomWidget().showSnackBar(context, 'Opensearch script executed.');
  }

  Future<void> anotherFunction(BuildContext context) async {
    String alPythonScriptPath = 'app/Algorithm.py';
    CustomWidget().showSnackBar(context, 'Running Algorithm script...');
    ProcessResult result = await Process.run('python', [alPythonScriptPath]);
    print('\n${result.stdout}');
    await _loadDataFromFile();
    setState(() {});
    CustomWidget().showSnackBar(context, 'Algorithm script executed.');
    String errorMessage = await _readError_al();
    CustomWidget().showErrorDialog(context, 'Error', errorMessage);
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
}
