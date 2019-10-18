import 'package:azair_client/general/page/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(AzairClient());

class AzairClient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'AZair',
      theme: ThemeData.dark(),
      home: SplashPage(),
    );
  }
}
