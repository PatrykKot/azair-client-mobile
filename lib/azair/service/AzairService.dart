import 'dart:convert';

import 'package:azair_client/azair/model/AirportModel.dart';
import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/service/AzairResponseParser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const _BASE_URL = "http://www.azair.cz/azfin.php";

class AzairService {
  final parser = AzairResponseParser();

  Future<List<AirportModel>> fetchAirports(BuildContext context) async {
    final Map<String, dynamic> airportsJson = jsonDecode(
        await DefaultAssetBundle.of(context)
            .loadString("assets/json/airports.json"));

    final airports = List<AirportModel>();
    airportsJson.keys.forEach((key) {
      airports.add(AirportModel.fromMap(airportsJson[key]));
    });

    return airports;
  }

  Future<List<ResultModel>> findResults(SearchModel searchModel) async {
    final departureDate =
    DateTime.fromMillisecondsSinceEpoch(searchModel.departureDate);
    final arrivalDate =
    DateTime.fromMillisecondsSinceEpoch(searchModel.arrivalDate);

    final dio = Dio();
    final response = await dio.get(_BASE_URL,
        queryParameters: {
          "searchtype": "flexi",
          "tp": "0",
          "isOneway": "return",
          "srcAirport": "(+SZY,LUZ,KTW)",
          "dstAirport": "(+LHR)",
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
        },
        options: Options(headers: {'Cookie': 'lang=pl'}));

    if (response.statusCode == 200) {
      return parser.parse(response.data);
    } else {
      throw Exception('Cannot fetch results');
    }
  }
}
