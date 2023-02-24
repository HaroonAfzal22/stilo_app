import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SchedaProdotto extends StatefulWidget {
  const SchedaProdotto({Key? key}) : super(key: key);
  static const routeName = 'scheda-prodotto-screen';

  @override
  State<SchedaProdotto> createState() => _SchedaProdottoState();
}

class _SchedaProdottoState extends State<SchedaProdotto> {
  String? scheda;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scheda = ModalRoute.of(context)?.settings.arguments as String;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheda prodotto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              if (scheda != null)
                Html(
                  data: scheda,
                ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
