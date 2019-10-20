import 'package:azair_client/azair/page/DatePeriodPickerPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePeriodPicker extends StatelessWidget {
  final int fromDate;
  final int toDate;
  final Function onChange;

  DatePeriodPicker({this.fromDate, this.toDate, this.onChange});

  void onClick(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DatePeriodPickerPage(
                fromDate: fromDate,
                toDate: toDate,
              )),
    ) as List<int>;

    if (result != null) {
      onChange(result[0], result[1]);
    }
  }

  Widget periodWidget(BuildContext context) {
    if (fromDate != null && toDate != null) {
      final fromDateString = DateFormat('dd-MM-yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(fromDate));
      final toDateString = DateFormat('dd-MM-yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(toDate));

      return RichText(
        text: TextSpan(style: TextStyle(fontSize: 18), children: [
          TextSpan(
              text: "Od  ",
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
          TextSpan(text: fromDateString),
          TextSpan(
              text: "  do  ",
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
          TextSpan(text: toDateString),
        ]),
      );
    } else {
      return Text(
        'Wybierz zakres czasu',
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.calendar_today),
            Padding(
              padding: EdgeInsets.only(right: 4),
            ),
            Text(
              'Termin',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: () {
            onClick(context);
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(child: periodWidget(context)),
                ),
              ),
            ),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
