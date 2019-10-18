import 'package:azair_client/azair/model/AirportModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/page/ResultsPage.dart';
import 'package:azair_client/azair/service/AzairService.dart';
import 'package:azair_client/azair/widget/field/AirportPicker.dart';
import 'package:azair_client/azair/widget/field/LongCounterField.dart';
import 'package:azair_client/general/widget/Logo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final List<AirportModel> airports;

  SearchPage({this.airports});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var minDays = 2;
  var maxDays = 5;
  var adults = 1;
  var maxChangesCount = 0;
  final fromAirports = List<AirportModel>();
  final toAirports = List<AirportModel>();

  final azairService = AzairService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> goToResults() async {
    final searchModel = SearchModel(
        adults: adults,
        maxChangesCount: maxChangesCount,
        maxDaysStay: maxDays,
        minDaysStay: minDays,
        fromAirports: fromAirports,
        toAirports: toAirports,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: goToResults,
          child: Icon(Icons.search),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: SizedBox(
                    height: 150,
                    child: FittedBox(fit: BoxFit.fill, child: Logo())),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: AirportPicker(
                      label: "Z lotniska",
                      airports: widget.airports,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 15,
                    child: LongCounterField(
                      min: 0,
                      max: 10,
                      value: adults,
                      onChange: (value) {
                        setState(() {
                          adults = value;
                        });
                      },
                      label: "Liczba osób",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 15,
                    child: LongCounterField(
                      min: 0,
                      max: 30,
                      value: minDays,
                      onChange: (value) {
                        setState(() {
                          minDays = value;

                          if (minDays > maxDays) {
                            maxDays = minDays;
                          }
                        });
                      },
                      label: "Minimalna liczba dni",
                    ),
                  ),
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 15,
                    child: LongCounterField(
                      min: 0,
                      max: 30,
                      value: maxDays,
                      onChange: (value) {
                        setState(() {
                          maxDays = value;

                          if (minDays > maxDays) {
                            minDays = maxDays;
                          }
                        });
                      },
                      label: "Maksymalna liczba dni",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: LongCounterField(
                      min: 0,
                      max: 5,
                      value: maxChangesCount,
                      onChange: (value) {
                        setState(() {
                          maxChangesCount = value;
                        });
                      },
                      label: "Maksymalna liczba przesiadek",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
