import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seong_flutter/screen/home_view_model.dart';
import 'package:seong_flutter/sc'
    'reen/widget/log_time_picker.dart';
import 'package:seong_flutter/screen/widget/criteria_input_field.dart';
import 'package:seong_flutter/screen/widget/log_data_table.dart';

import 'widget/my_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textFieldController1 = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();

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
              /// Header영역 (inputFields)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 제일 위로 붙도록 정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CriteriaInputField(
                      textController1: textFieldController1,
                      textController2: textFieldController2),
                  LogTimePicker(
                      textController1: textFieldController1,
                      textController2: textFieldController2),
                  rowButtons(context),
                ],
              ),
              const SizedBox(height: 40),
              LogDataTable(tableData: vm.tableData),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyWidget().defaultButton(() {
              vm.runPythonScript(context);
            }, 'Download'),
            const SizedBox(width: 10),
            MyWidget().defaultButton(() {
              vm.anotherFunction(context);
            }, 'Algorithm'),
            const SizedBox(width: 10),
            MyWidget().defaultButton(() {
              vm.saveOpenSearch(context);
            }, 'Opensearch'),
          ],
        ),
        const SizedBox(height: 40),
        if (vm.isRun) const CircularProgressIndicator(),
      ],
    );
  }

  // Widget _buildActionButton(String label, Function onPressed) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         if (_formKey.currentState?.validate() ?? false) {
  //           onPressed(context);
  //         }
  //       },
  //       child: Text(label),
  //     ),
  //   );
  // }
}
