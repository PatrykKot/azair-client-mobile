import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:flutter/material.dart';

class AirportsChipList extends StatelessWidget {
  final List<AirportEntry> airports;
  final List<String> selectedAirportIds;
  final Function onDelete;
  final String emptyText;

  AirportsChipList(
      {this.airports, this.selectedAirportIds, this.onDelete, this.emptyText});

  List<AirportEntry> get selectedAirports {
    return selectedAirportIds.map((airportId) {
      return airports.firstWhere((airport) => airport.id == airportId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedAirportIds.isEmpty) {
      return Center(
          child: Text(
        emptyText ?? '',
        style: TextStyle(color: Theme.of(context).primaryColorLight),
      ));
    } else {
      return ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: selectedAirports
            .map((airport) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Chip(
                    label: Text(airport.name),
                    deleteIcon: Icon(Icons.clear),
                    onDeleted: () {
                      onDelete(airport.id);
                    },
                  ),
                ))
            .toList(),
      );
    }
  }
}
