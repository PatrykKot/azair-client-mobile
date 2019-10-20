import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html;

import '../model/FlightModel.dart';

class AzairResponseParser {
  Future<List<ResultModel>> parse(String htmlResponse) async {
    return await compute(_parseIsolate, htmlResponse);
  }

  static List<ResultModel> _parseIsolate(String htmlResponse) {
    final htmlDocument = html.parse(htmlResponse);

    return htmlDocument.getElementsByClassName("result").map((htmlResult) {
      htmlResult
          .getElementsByClassName("code")
          .forEach((item) => item.remove());
      final totalPriceHtml = htmlResult.getElementsByClassName("totalPrice")[0];

      return ResultModel(
          id: htmlResult.id,
          price: totalPriceHtml.getElementsByClassName("tp")[0].text,
          lengthOfStay:
              totalPriceHtml.getElementsByClassName("lengthOfStay")[0].text,
          fromFlight: FlightModel(
              from:
                  splitEnter(htmlResult.getElementsByClassName("from")[0].text),
              to: splitEnter(htmlResult.getElementsByClassName("to")[0].text)),
          toFlight: FlightModel(
              from:
                  splitEnter(htmlResult.getElementsByClassName("from")[2].text),
              to: splitEnter(htmlResult.getElementsByClassName("to")[2].text)));
    }).toList();
  }
}

String splitEnter(String text) {
  return text.split("\n")[0];
}
