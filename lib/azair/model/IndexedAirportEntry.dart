import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:diacritic/diacritic.dart';

class IndexedAirportEntry {
  String nameIndex;
  AirportEntry airport;

  IndexedAirportEntry({AirportEntry airport}) {
    this.nameIndex = removeDiacritics(airport.name.toLowerCase().trim());
    this.airport = airport;
  }
}
