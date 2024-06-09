import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:seong_flutter/screen/home_view_model.dart';
import 'package:seong_flutter/screen/widget/my_widget.dart';

class LogTimePicker extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;

  const LogTimePicker(
      {super.key,
      required this.textController1,
      required this.textController2});

  @override
  State<LogTimePicker> createState() => _LogTimePickerState();
}

class _LogTimePickerState extends State<LogTimePicker> {
  DateTime? selectedDateTime;
  final controller = BoardDateTimeController();

  DateTime date = DateTime.now();

  Future<void> formattedAndSave(DateTime? dateTime) async {
    String formattedDateTime = DateFormat('yyyyMMdd HH').format(dateTime!);
    print('Selected DateTime: $formattedDateTime');
    await HomeViewModel().saveToFile(formattedDateTime);

    setState(() {
      selectedDateTime = dateTime;
    });
    await HomeViewModel().saveToFile(
        '${widget.textController1.text} ${widget.textController2.text}',
        append: true);
  }

  // Future<void> _selectDateTime(BuildContext context) async {
  //   DateTime date = DateTime.now();
  //   TimeOfDay time = TimeOfDay.now();
  //
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: date,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //
  //   if (pickedDate != null) {
  //     final TimeOfDay? pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: time,
  //     );
  //
  //     if (pickedTime != null) {
  //       final DateTime pickedDateTime = DateTime(
  //         pickedDate.year,
  //         pickedDate.month,
  //         pickedDate.day,
  //         pickedTime.hour,
  //         pickedTime.minute,
  //       );
  //
  //       String formattedDateTime =
  //           DateFormat('yyyyMMdd HH').format(pickedDateTime);
  //       print('Selected DateTime: $formattedDateTime');
  //       await HomeViewModel().saveToFile(formattedDateTime);
  //
  //       setState(() {
  //         selectedDateTime = pickedDateTime;
  //       });
  //       await HomeViewModel().saveToFile(
  //           '${widget.textController1.text} ${widget.textController2.text}',
  //           append: true);
  //     }
  //   }
  // }

  @override
  void initState() {
    selectedDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            MyWidget().defaultButton(
              () async {
                // _selectDateTime(context);
                DateTime? dateTime = await _showDateTimePicker(context);

                // Cancel버튼을 누르면 null임.
                if (dateTime != null) {
                  formattedAndSave(dateTime);
                }
              },
              'Calendar',
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) {
    return showOmniDateTimePicker(
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
      ),
      title: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: const Text(
          "날짜와 시간을 선택해주세요",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      separator: Divider(),
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
  }
}
