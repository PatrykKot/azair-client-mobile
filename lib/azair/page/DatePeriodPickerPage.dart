import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/iterables.dart' as quiver;

const _NEXT_MONTHS_COUNT = 12;

class DatePeriodPickerPage extends StatefulWidget {
  final int fromDate;
  final int toDate;

  DatePeriodPickerPage({this.fromDate, this.toDate});

  @override
  _DatePeriodPickerPageState createState() => _DatePeriodPickerPageState();
}

class _DatePeriodPickerPageState extends State<DatePeriodPickerPage> {
  final monthModels = List<MonthModel>();
  var selectingStartDate = true;
  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() {
    startDate = widget.fromDate != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.fromDate)
        : null;
    endDate = widget.toDate != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.toDate)
        : null;

    final now = DateTime.now();
    final monthFormat = DateFormat('MMMM', 'pl');
    var tempTime = DateTime(now.year, now.month, 1);

    Iterable<int>.generate(_NEXT_MONTHS_COUNT).forEach((_) {
      final month = tempTime.month;
      final year = tempTime.year;
      final startingWeekDay = tempTime.weekday - 1;

      final days = List<DayModel>();
      while (tempTime.month == month) {
        days.add(DayModel(time: tempTime));
        tempTime = tempTime.add(Duration(days: 1));
      }

      final monthModel = MonthModel(
          month: month,
          year: year,
          name: monthFormat.format(DateTime(year, month, 1)),
          days: days,
          startingDayWeek: startingWeekDay);

      monthModels.add(monthModel);
    });
  }

  onSaveClick() async {
    Navigator.of(context).pop(
        [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch]);
  }

  onDaySelect(DateTime time) {
    setState(() {
      if (selectingStartDate) {
        startDate = time;
        endDate = null;
        selectingStartDate = false;
      } else if (time.isBefore(startDate) || time == startDate) {
        startDate = time;
      } else {
        endDate = time;
        selectingStartDate = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wybierz zakres czasu"),
      ),
      floatingActionButton: startDate != null && endDate != null
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: onSaveClick,
                child: Icon(Icons.save),
              ),
            )
          : null,
      body: body,
    );
  }

  Widget get body {
    return Column(
      children: <Widget>[
        Ink(
          color: Colors.black45,
          child: Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Row(
                  children: ['Pn', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Ndz']
                      .map((day) => dayWeekHeaderWidget(day))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return monthWidget(monthModels[index]);
            },
            itemCount: monthModels.length,
          ),
        ),
      ],
    );
  }

  Widget dayWeekHeaderWidget(String text) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ))),
    );
  }

  Widget monthWidget(MonthModel monthModel) {
    return Column(
      children: <Widget>[monthHeader(monthModel), monthContent(monthModel)],
    );
  }

  Widget monthHeader(MonthModel monthModel) {
    return Row(
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Center(child: Text('${monthModel.name} ${monthModel.year}')),
            ),
          ),
        ),
      ],
    );
  }

  Widget monthContent(MonthModel monthModel) {
    final startDateEpoch =
        startDate != null ? startDate.millisecondsSinceEpoch : null;
    final endDateEpoch =
        endDate != null ? endDate.millisecondsSinceEpoch : null;

    final List<Widget> dayWidgets = monthModel.days.map((day) {
      final epoch = day.time.millisecondsSinceEpoch;
      var inRange = false;

      if (startDateEpoch != null || endDateEpoch != null) {
        if (startDateEpoch == epoch || endDateEpoch == epoch) {
          inRange = true;
        } else if (startDateEpoch != null && endDateEpoch != null) {
          inRange = epoch >= startDateEpoch && epoch <= endDateEpoch;
        }
      }

      return Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          onTap: () => onDaySelect(day.time),
          child: Container(
              decoration: BoxDecoration(
                color: inRange
                    ? Colors.blue
                    : Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(day.time.day.toString()),
              ))),
        ),
      );
    }).toList();

    Iterable<int>.generate(monthModel.startingDayWeek).forEach((_) {
      dayWidgets.insert(
          0,
          Flexible(
            fit: FlexFit.tight,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(''),
                ))),
          ));
    });

    while (dayWidgets.length % 7 != 0) {
      dayWidgets.add(Flexible(
        fit: FlexFit.tight,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            ))),
      ));
    }
    final groupedDays = quiver.partition(dayWidgets, 7);

    final rows = groupedDays
        .map((weekDays) => Row(
              children: weekDays,
            ))
        .toList();

    return Column(
      children: rows,
    );
  }
}

class MonthModel {
  final int month;
  final int year;
  final String name;
  final List<DayModel> days;
  final int startingDayWeek;

  MonthModel(
      {this.name, this.month, this.year, this.days, this.startingDayWeek});
}

class DayModel {
  final DateTime time;

  DayModel({this.time});
}
