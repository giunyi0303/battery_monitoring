import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel._();
  static final HomeViewModel _instance = HomeViewModel._();

  factory HomeViewModel() {
    return _instance;
  }

  List<List<String>> tableData = [];

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
}
