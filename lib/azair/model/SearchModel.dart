import 'package:azair_client/azair/model/AirportModel.dart';

class SearchModel {
  int adults;
  int maxChangesCount;
  String currency;
  int minDaysStay;
  int maxDaysStay;
  int departureDate;
  int arrivalDate;
  List<AirportModel> fromAirports;
  List<AirportModel> toAirports;

  SearchModel(
      {this.adults,
      this.maxChangesCount,
      this.currency,
      this.departureDate,
      this.arrivalDate,
      this.maxDaysStay,
      this.minDaysStay,
      this.fromAirports,
      this.toAirports});
}
