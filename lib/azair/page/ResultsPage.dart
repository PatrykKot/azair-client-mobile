import 'package:azair_client/azair/model/ResultModel.dart';
import 'package:azair_client/azair/model/SearchModel.dart';
import 'package:azair_client/azair/service/AzairService.dart';
import 'package:azair_client/azair/widget/ResultTile.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final SearchModel searchModel;

  ResultsPage({this.searchModel});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final results = List<ResultModel>();
  var loading = false;

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

    final fetchedResults = await azairService.findResults(widget.searchModel);

    setState(() {
      results.clear();
      results.addAll(fetchedResults);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wyniki wyszukiwania'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ResultTile(
                  result: results[index],
                );
              },
            ),
    );
  }
}
