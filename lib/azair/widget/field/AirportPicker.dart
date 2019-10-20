import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:azair_client/azair/page/AirportPickerPage.dart';
import 'package:azair_client/azair/widget/AirportsChipList.dart';
import 'package:flutter/material.dart';

class AirportPicker extends StatefulWidget {
  final List<AirportEntry> airports;
  final String label;
  final Widget leading;
  final List<String> selectedAirportIds;
  final Function onChange;

  AirportPicker(
      {this.airports,
      this.label,
      this.leading,
      this.selectedAirportIds,
      this.onChange});

  @override
  _AirportPickerState createState() => _AirportPickerState();
}

class _AirportPickerState extends State<AirportPicker> {
  onClick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AirportPickerPage(
                airports: widget.airports,
                selectedAirportIds: widget.selectedAirportIds,
              )),
    ) as List<String>;

    if (result != null) {
      widget.onChange(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.leading,
            Padding(
              padding: EdgeInsets.only(right: 4),
            ),
            Text(
              widget.label,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: onClick,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AirportsChipList(
                    emptyText: "Wybierz lotniska",
                    selectedAirportIds: widget.selectedAirportIds,
                    airports: widget.airports,
                    onDelete: (airportId) {
                      final result =
                          List<String>.from(widget.selectedAirportIds)
                              ..removeWhere((id) => id == airportId);
                      widget.onChange(result);
                    },
                  ),
                ),
              ),
            ),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
