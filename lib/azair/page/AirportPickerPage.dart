import 'package:azair_client/azair/model/AirportModel.dart';
import 'package:flutter/material.dart';

class AirportPickerPage extends StatefulWidget {
  final List<AirportModel> airports;

  AirportPickerPage({this.airports});

  @override
  _AirportPickerPageState createState() => _AirportPickerPageState();
}

class _AirportPickerPageState extends State<AirportPickerPage> {
  final sortedAirports = List<AirportModel>();
  final filteredAirports = List<AirportModel>();

  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final items = List<AirportModel>.from(widget.airports);
    items.sort((item1, item2) => item1.name.compareTo(item2.name));

    setState(() {
      sortedAirports.addAll(items);
      filteredAirports.addAll(items);
    });

    filterController.addListener(filter);
  }

  @override
  void dispose() {
    filterController.dispose();

    super.dispose();
  }

  void filter() {
    final filterText = filterController.text.trim().toLowerCase();
    final items = sortedAirports
        .where((item) => item.name.toLowerCase().contains(filterText));

    setState(() {
      filteredAirports.clear();
      filteredAirports.addAll(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Szukaj lotnisk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: filterController,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Wpisz nazwę kraju, miasta, lotniska"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAirports.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                    title: Text(filteredAirports[index].name),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
