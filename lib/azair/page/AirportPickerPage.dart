import 'package:azair_client/azair/model/AirportEntry.dart';
import 'package:azair_client/azair/model/IndexedAirportEntry.dart';
import 'package:flutter/material.dart';

class AirportPickerPage extends StatefulWidget {
  final List<AirportEntry> airports;
  final List<String> selectedAirportIds;

  AirportPickerPage({this.airports, this.selectedAirportIds});

  @override
  _AirportPickerPageState createState() => _AirportPickerPageState();
}

class _AirportPickerPageState extends State<AirportPickerPage> {
  final sortedAirports = List<IndexedAirportEntry>();
  final filteredAirports = List<IndexedAirportEntry>();

  final selectedAirportIds = List<String>();

  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final items = widget.airports
        .map((item) => IndexedAirportEntry(airport: item))
        .toList();
    items.sort((item1, item2) => item1.nameIndex.compareTo(item2.nameIndex));

    setState(() {
      selectedAirportIds.addAll(widget.selectedAirportIds);
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
        .where((item) => item.nameIndex.toLowerCase().contains(filterText));

    setState(() {
      filteredAirports.clear();
      filteredAirports.addAll(items);
    });
  }

  onSaveClick() {
    Navigator.of(context).pop(selectedAirportIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Szukaj lotnisk"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                selectedAirportIds.clear();
              });
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: onSaveClick,
          child: Icon(Icons.done),
        ),
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: filteredAirports.length,
                itemBuilder: (context, index) {
                  final indexedAirpport = filteredAirports[index];
                  final airport = indexedAirpport.airport;

                  final selected = selectedAirportIds
                      .where((item) => item == airport.id)
                      .isNotEmpty;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).cardColor
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          style: BorderStyle.none,
                        )),
                    child: ListTile(
                      selected: selected,
                      title: Text(airport.name),
                      subtitle: airport.allAirports
                          ? Text("Wszystkie lotniska")
                          : null,
                      onTap: () {
                        setState(() {
                          if (selected) {
                            selectedAirportIds
                                .removeWhere((item) => item == airport.id);
                          } else {
                            selectedAirportIds.add(airport.id);
                          }
                        });
                      },
                    ),
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
