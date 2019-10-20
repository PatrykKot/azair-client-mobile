import 'dart:convert';

import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/service/AzairResponseParser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const BASE_URL = "http://www.azair.cz/azfin.php";

class AzairService {
  final parser = AzairResponseParser();

  Future<List<AirportEntry>> fetchAirports(BuildContext context) async {
    final airports = List<AirportEntry>();

    airports.addAll(await loadGroupedAirports(context));
    airports.addAll(await loadSingleAirports(context));

    return airports;
  }

  Future<List<AirportEntry>> loadSingleAirports(BuildContext context) async {
    final Map<String, dynamic> airportsJson = jsonDecode(
        await DefaultAssetBundle.of(context)
            .loadString("assets/json/airports.json"));
    final Map<String, dynamic> airportsPlJson = jsonDecode(
        await DefaultAssetBundle.of(context)
            .loadString("assets/json/airportsPl.json"));

    airportsJson.addEntries(airportsPlJson.entries);

    final result = List<AirportEntry>();
    airportsJson.keys.forEach((key) {
      result.add(AirportEntry(
          allAirports: false,
          id: key,
          ports: [key],
          name: airportsJson[key] as String));
    });

    return result;
  }

  Future<List<AirportEntry>> loadGroupedAirports(BuildContext context) async {
    final Map<String, dynamic> groupedAirportsJson = jsonDecode(
        await DefaultAssetBundle.of(context)
            .loadString("assets/json/groupedAirports.json"));

    final result = List<AirportEntry>();
    groupedAirportsJson.keys.forEach((key) {
      result.add(AirportEntry(
          id: key,
          allAirports: true,
          name: (groupedAirportsJson[key]['name'] as String),
          ports: (groupedAirportsJson[key]['ports'] as String).split('_')));
    });

    return result;
  }

  Future<List<ResultModel>> findResults(
      SearchModel searchModel, List<AirportEntry> airports) async {
    final dio = Dio();
    final response = await dio.get(BASE_URL,
        queryParameters: _getQueryParameters(searchModel, airports),
        options: Options(headers: {'Cookie': 'lang=pl'}));

    if (response.statusCode == 200) {
      return parser.parse(response.data);
    } else {
      throw Exception('Cannot fetch results');
    }
  }

  String getQueryString(SearchModel searchModel, List<AirportEntry> airports) {
    final parameters = _getQueryParameters(searchModel, airports);
    return parameters.keys.map((key) {
      return '$key=${Uri.encodeQueryComponent(parameters[key].toString())}';
    }).join('&');
  }

  Map<String, dynamic> _getQueryParameters(
      SearchModel searchModel, List<AirportEntry> airports) {
    final departureDate =
        DateTime.fromMillisecondsSinceEpoch(searchModel.departureDate);
    final arrivalDate =
        DateTime.fromMillisecondsSinceEpoch(searchModel.arrivalDate);

    final fromAirports = searchModel.fromAirports.map((airportId) {
      return airports.firstWhere((airport) => airport.id == airportId);
    });
    final fromAirportsString =
        fromAirports.expand((airport) => airport.ports).join(',');

    final toAirports = searchModel.toAirports.map((airportId) {
      return airports.firstWhere((airport) => airport.id == airportId);
    });
    final toAirportsString =
        toAirports.expand((airport) => airport.ports).join(',');

    return {
      "searchtype": "flexi",
      "tp": "0",
      "isOneway": "return",
      "srcAirport": "(+$fromAirportsString)",
      "dstAirport": "(+$toAirportsString)",
      "dstMC": "ROM_ALL",
      "depmonth": DateFormat('yyyyMM').format(departureDate),
      "depdate": DateFormat('yyyy-MM-dd').format(departureDate),
      "aid": "0",
      "arrmonth": DateFormat('yyyyMM').format(arrivalDate),
      "arrdate": DateFormat('yyyy-MM-dd').format(arrivalDate),
      "minDaysStay": searchModel.minDaysStay,
      "maxDaysStay": searchModel.maxDaysStay,
      "samedep": "true",
      "samearr": "true",
      "minHourStay": "0:45",
      "maxHourStay": "23:20",
      "minHourOutbound": "0:00",
      "maxHourOutbound": "24:00",
      "minHourInbound": "0:00",
      "maxHourInbound": "24:00",
      "autoprice": "true",
      "adults": searchModel.adults,
      "children": 0,
      "infants": 0,
      "maxChng": searchModel.maxChangesCount,
      "currency": "PLN",
      "indexSubmit": "Szukaj",
    };
  }
}
