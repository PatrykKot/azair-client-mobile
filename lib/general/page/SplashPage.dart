import 'package:azair_client/azair/page/SearchPage.dart';
import 'package:azair_client/azair/service/AzairService.dart';
import 'package:azair_client/general/widget/Logo.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final azairService = AzairService();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await initializeDateFormatting();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Logo(),
        ),
      ),
    );
  }
}
