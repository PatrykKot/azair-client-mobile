import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/page/ResultsPage.dart';
import 'package:azair_client/azair/widget/field/LongField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var minDays = 2;
  var maxDays = 5;
  var adults = 1;
  var children = 0;
  var infants = 0;

  Future<void> goToResults() async {
    final searchModel = SearchModel(
        children: children,
        adults: adults,
        infants: infants,
        currency: 'PLN',
        maxChangesCount: 0,
        maxDaysStay: maxDays,
        minDaysStay: minDays,
        departureDate:
            DateFormat('yyyy-MM-dd').parse('2020-01-01').millisecondsSinceEpoch,
        arrivalDate: DateFormat('yyyy-MM-dd')
            .parse('2020-02-29')
            .millisecondsSinceEpoch);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultsPage(searchModel: searchModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Szukaj lotów"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToResults,
        child: Icon(Icons.search),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: LongField(
                    initialValue: minDays,
                    onChange: (value) {
                      setState(() {
                        minDays = value;
                      });
                    },
                    label: "Minimalna liczba dni",
                  ),
                ),
                Flexible(
                  child: LongField(
                    initialValue: maxDays,
                    onChange: (value) {
                      setState(() {
                        maxDays = value;
                      });
                    },
                    label: "Maksymalna liczba dni",
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: LongField(
                    initialValue: adults,
                    onChange: (value) {
                      setState(() {
                        adults = value;
                      });
                    },
                    label: "Dorośli",
                  ),
                ),
                Flexible(
                  child: LongField(
                    initialValue: children,
                    onChange: (value) {
                      setState(() {
                        children = value;
                      });
                    },
                    label: "Dzieci",
                  ),
                ),
                Flexible(
                  child: LongField(
                    initialValue: infants,
                    onChange: (value) {
                      setState(() {
                        infants = value;
                      });
                    },
                    label: "Niemowlęta",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
