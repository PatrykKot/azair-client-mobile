import 'package:azair_client/azair/model/FlightModel.dart';
import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

const _BASE_URL = "http://www.azair.cz/azfin.php";

class AzairService {
  Future<List<ResultModel>> findResults(SearchModel searchModel) async {
    final departureDate = DateTime.fromMillisecondsSinceEpoch(searchModel.departureDate);
    final arrivalDate = DateTime.fromMillisecondsSinceEpoch(searchModel.arrivalDate);

    final dio = Dio();
    final response = await dio.get(_BASE_URL,
        queryParameters: {
          "searchtype": "flexi",
          "tp": "0",
          "isOneway": "return",
          "srcAirport": "Wrocław [WRO]",
          "dstAirport": "Rzym [FCO] (+CIA)",
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
          "children": searchModel.children,
          "infants": searchModel.infants,
          "maxChng": searchModel.maxChangesCount,
          "currency": searchModel.currency,
          "indexSubmit": "Szukaj",
        },
        options: Options(headers: {'Cookie': 'lang=pl'}));

    if (response.statusCode == 200) {
      final data = response.data;
      final htmlDocument = parse(data);

      return htmlDocument.getElementsByClassName("result").map((htmlResult) {
        htmlResult
            .getElementsByClassName("code")
            .forEach((item) => item.remove());
        final totalPriceHtml =
            htmlResult.getElementsByClassName("totalPrice")[0];

        return ResultModel(
            id: htmlResult.id,
            price: totalPriceHtml.getElementsByClassName("tp")[0].text,
            lengthOfStay:
                totalPriceHtml.getElementsByClassName("lengthOfStay")[0].text,
            fromFlight: FlightModel(
                from: splitEnter(
                    htmlResult.getElementsByClassName("from")[0].text),
                to: splitEnter(
                    htmlResult.getElementsByClassName("to")[0].text)),
            toFlight: FlightModel(
                from: splitEnter(
                    htmlResult.getElementsByClassName("from")[2].text),
                to: splitEnter(
                    htmlResult.getElementsByClassName("to")[2].text)));
      }).toList();
    } else {
      throw Exception('Cannot fetch results');
    }
  }
}

String splitEnter(String text) {
  return text.split("\n")[0];
}
