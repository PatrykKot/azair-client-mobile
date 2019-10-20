import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/service/AzairService.dart';
import 'package:azair_client/azair/widget/ResultTile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsPage extends StatefulWidget {
  final SearchModel searchModel;

  ResultsPage({this.searchModel});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final results = List<ResultModel>();
  var loading = false;
  var selectedSort = 'priceAsc';

  final azairService = AzairService();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    setState(() {
      loading = true;
    });

    final fetchedResults = await azairService.findResults(
        widget.searchModel, await azairService.fetchAirports(context));

    setState(() {
      results.clear();
      results.addAll(fetchedResults);
      loading = false;
    });
  }

  onOpenInBrowserClick() async {
    final query = azairService.getQueryString(
        widget.searchModel, await azairService.fetchAirports(context));
    launch('$BASE_URL?$query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wyniki wyszukiwania'),
        actions: <Widget>[
          IconButton(
            onPressed: onOpenInBrowserClick,
            icon: Icon(Icons.open_in_browser),
          )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : body,
    );
  }

  Widget get body {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: sortPopup,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ResultTile(
                result: results[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget get sortPopup {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          if(value == selectedSort) {
            selectedSort = null;
          }
          else {
            selectedSort = value;
          }
        });
      },
      offset: Offset(1, 0),
      itemBuilder: (context) {
        return [
          sortItem('Cena: rosnąco', true, 'priceAsc'),
          sortItem('Cena: malejąco', false, 'priceDesc'),
          sortItem('Liczba dni: rosnąco', true, 'stayDaysAsc'),
          sortItem('Liczba dni: malejąco', false, 'stayDaysDesc'),
          sortItem('Data wylotu: rosnąco', true, 'departureDateAsc'),
          sortItem('Data wylotu: malejąco', false, 'departureDateDesc'),
        ];
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.solid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text("Sortuj"), Icon(Icons.sort)],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> sortItem(
      String text, bool asc, String value) {
    return PopupMenuItem<String>(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text,
              style: TextStyle(
                  color: selectedSort == value
                      ? Theme.of(context).textSelectionColor
                      : Theme.of(context).textTheme.display1.color)),
          Icon(asc ? Icons.arrow_upward : Icons.arrow_downward)
        ],
      ),
      value: value,
    );
  }
}
