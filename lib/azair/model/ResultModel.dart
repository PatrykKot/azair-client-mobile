import 'package:azair_client/azair/model/FlightModel.dart';

class ResultModel {
  final String id;
  final String price;
  final String lengthOfStay;
  final FlightModel toFlight;
  final FlightModel fromFlight;

  ResultModel(
      {this.id, this.price, this.lengthOfStay, this.fromFlight, this.toFlight});
}
