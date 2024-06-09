import 'package:flutter/material.dart';

class LogDataTable extends StatefulWidget {
  final List<List<String>> tableData;
  final double dataTableWidth;
  const LogDataTable(
      {super.key, required this.dataTableWidth, required this.tableData});

  @override
  State<LogDataTable> createState() => _LogDataTableState();
}

class _LogDataTableState extends State<LogDataTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dataTableWidth,
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
        rows: widget.tableData.map((rowData) {
          return DataRow(
              cells: rowData.map((data) => DataCell(Text(data))).toList());
        }).toList(),
      ),
    );
  }
}
