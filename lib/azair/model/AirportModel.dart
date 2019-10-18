class AirportModel {
  String icao;
  String iata;
  String name;
  String city;
  String state;
  String country;
  String tz;

  static AirportModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    AirportModel airportModelBean = AirportModel();
    airportModelBean.icao = map['icao'];
    airportModelBean.iata = map['iata'];
    airportModelBean.name = map['name'];
    airportModelBean.city = map['city'];
    airportModelBean.state = map['state'];
    airportModelBean.country = map['country'];
    airportModelBean.tz = map['tz'];
    return airportModelBean;
  }

  Map toJson() => {
        "icao": icao,
        "iata": iata,
        "name": name,
        "city": city,
        "state": state,
        "country": country,
        "tz": tz,
      };
}
