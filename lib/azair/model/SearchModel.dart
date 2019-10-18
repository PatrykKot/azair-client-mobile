class SearchModel {
  int adults;
  int children;
  int infants;
  int maxChangesCount;
  String currency;
  int minDaysStay;
  int maxDaysStay;
  int departureDate;
  int arrivalDate;

  SearchModel(
      {this.adults,
      this.children,
      this.infants,
      this.maxChangesCount,
      this.currency,
      this.departureDate,
      this.arrivalDate,
      this.maxDaysStay,
      this.minDaysStay});
}
