import 'dart:math' as math;

import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/page/ResultsPage.dart';
import 'package:azair_client/azair/service/AzairService.dart';
import 'package:azair_client/azair/widget/field/AirportPicker.dart';
import 'package:azair_client/azair/widget/field/DatePeriodPicker.dart';
import 'package:azair_client/azair/widget/field/LongCounterField.dart';
import 'package:azair_client/general/widget/Logo.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchModel = SearchModel(
      minDaysStay: 2,
      maxDaysStay: 5,
      adults: 1,
      maxChangesCount: 0,
      fromAirports: [],
      toAirports: [],
      departureDate: null,
      arrivalDate: null);

  final airports = List<AirportEntry>();

  final azairService = AzairService();

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    final items = await azairService.fetchAirports(context);
    setState(() {
      airports.addAll(items);
    });
  }

  Future<void> goToResults() async {
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
                    height: 100,
                    child: FittedBox(fit: BoxFit.fill, child: Logo())),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: AirportPicker(
                      leading: Icon(Icons.airplanemode_active),
                      label: "Skąd",
                      airports: airports,
                      selectedAirportIds: searchModel.fromAirports,
                      onChange: (value) {
                        setState(() {
                          searchModel.fromAirports = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        final tempFromAirports =
                            List<String>.from(searchModel.fromAirports);
                        searchModel.fromAirports = searchModel.toAirports;
                        searchModel.toAirports = tempFromAirports;
                      });
                    },
                    icon: Icon(Icons.sync),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: AirportPicker(
                      leading: Transform.rotate(
                          angle: math.pi,
                          child: Icon(Icons.airplanemode_active)),
                      label: "Dokąd",
                      airports: airports,
                      selectedAirportIds: searchModel.toAirports,
                      onChange: (value) {
                        setState(() {
                          searchModel.toAirports = value;
                        });
                      },
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
                    child: DatePeriodPicker(
                        fromDate: searchModel.departureDate,
                        toDate: searchModel.arrivalDate,
                        onChange: (from, to) {
                          setState(() {
                            searchModel.departureDate = from;
                            searchModel.arrivalDate = to;
                          });
                        }),
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
                      min: 1,
                      max: 10,
                      value: searchModel.adults,
                      onChange: (value) {
                        setState(() {
                          searchModel.adults = value;
                        });
                      },
                      label: "Liczba osób",
                      icon: Icons.person,
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
                      value: searchModel.minDaysStay,
                      onChange: (value) {
                        setState(() {
                          searchModel.minDaysStay = value;

                          if (searchModel.minDaysStay >
                              searchModel.maxDaysStay) {
                            searchModel.maxDaysStay = searchModel.minDaysStay;
                          }
                        });
                      },
                      label: "Minimalna liczba dni",
                      icon: Icons.timer,
                    ),
                  ),
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 15,
                    child: LongCounterField(
                      min: 0,
                      max: 30,
                      value: searchModel.maxDaysStay,
                      onChange: (value) {
                        setState(() {
                          searchModel.maxDaysStay = value;

                          if (searchModel.minDaysStay >
                              searchModel.maxDaysStay) {
                            searchModel.minDaysStay = searchModel.maxDaysStay;
                          }
                        });
                      },
                      label: "Maksymalna liczba dni",
                      icon: Icons.timer,
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
                      value: searchModel.maxChangesCount,
                      onChange: (value) {
                        setState(() {
                          searchModel.maxChangesCount = value;
                        });
                      },
                      label: "Maksymalna liczba przesiadek",
                      icon: Icons.refresh,
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
