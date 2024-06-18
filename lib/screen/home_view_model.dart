import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:seong_flutter/screen/widget/my_widget.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel._();
  static final HomeViewModel _instance = HomeViewModel._();

  factory HomeViewModel() {
    return _instance;
  }

  List<List<String>> tableData = [];
  bool isRun = false;

  // notifyListeners()는 View에 데이터가 변화 되었음을 알려주는 역할, 즉 데이터를 갱신 하는 역할을 함.
  void update() {
    notifyListeners();
  }

  Future<void> loadDataFromFile() async {
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
      tableData = loadedData;
    }

    // 순차적으로 위 코드들을 모두 실행을 끝내면 마지막에 update함수로 데이터 갱신
    update();
  }

  Future<void> saveToFile(String data, {bool append = false}) async {
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

  Future<void> runPythonScript(BuildContext context) async {
    String downPythonScriptPath = 'app/data_down.py';
    MyWidget().showSnackBar(context, 'Running Python script...');
    ProcessResult result = await Process.run('python', [downPythonScriptPath]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    String errorMessage = await _readErrorLog();
    MyWidget().showErrorDialog(context, 'Error', errorMessage);
    MyWidget().showSnackBar(context, 'Python script executed.');
    update();
  }

  Future<void> saveOpenSearch(BuildContext context) async {
    String saveOpenSearch = 'app/opensearch.py';
    MyWidget().showSnackBar(context, 'Running Opensearch script...');
    ProcessResult result = await Process.run('python', [saveOpenSearch]);
    print('\n${result.stdout}');
    print('stderr: ${result.stderr}');
    MyWidget().showSnackBar(context, 'Opensearch script executed.');
  }

  Future<void> anotherFunction(BuildContext context) async {
    String alPythonScriptPath = 'app/Algorithm.py';
    MyWidget().showSnackBar(context, 'Running Algorithm script...');
    ProcessResult result = await Process.run('python', [alPythonScriptPath]);
    print('\n${result.stdout}');
    await loadDataFromFile();
    update();
    MyWidget().showSnackBar(context, 'Algorithm script executed.');
    String errorMessage = await readErrorAl();
    MyWidget().showErrorDialog(context, 'Error', errorMessage);
  }

  Future<String> _readErrorLog() async {
    final directory = Directory.current;
    final path = directory.path;
    final errorLogFile = File('$path/error_data/error_log.csv');

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

  Future<String> readErrorAl() async {
    final directory = Directory.current;
    final path = directory.path;
    final errorLogFile = File('$path/error_data/error_algorithm.csv');

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
