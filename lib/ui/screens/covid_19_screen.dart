import 'package:flutter/material.dart';

class Covid19Screen extends StatelessWidget {
  const Covid19Screen({Key? key}) : super(key: key);
  static const routeName = '/covid-19-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Servizi',
        ),
      ),
    );
  }
}
