import 'package:azair_client/azair/page/SearchPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(AzairClient());

class AzairClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azair',
      theme: ThemeData(),
      home: SearchPage(),
    );
  }
}
