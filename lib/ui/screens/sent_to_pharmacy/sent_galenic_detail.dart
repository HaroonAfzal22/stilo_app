import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class GalenicDetailScreen extends StatefulWidget {
  const GalenicDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/galenic-detail-screen';

  @override
  State<GalenicDetailScreen> createState() => _GalenicDetailScreenState();
}

class _GalenicDetailScreenState extends State<GalenicDetailScreen> {
  dynamic galenic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      galenic = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
      ),
      body: galenic != null
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: galenic['images'] == null
                            ? Image.asset(
                                'assets/images/noImage.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                galenic['images'],
                                fit: BoxFit.cover,
                              )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14, left: 0, right: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: AppColors.lightBlue.withOpacity(0.85),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 40),
                          child: Text(
                            translate(context, "Prep. Galenica"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (galenic['created_date'] != null)
                      Text(
                        'Caricata il : ${DateFormat("dd MMMM yyyy HH:mm:ss", 'it').format(DateFormat(
                          "yyyy-MM-dd HH:mm:ss",
                        ).parse(galenic!['created_date']))}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 52, 52, 52),
                            fontWeight: FontWeight.w400,
                            fontSize: 17),
                      ),
                    if (galenic['notes'] != null)
                      Text('Note: ${galenic['notes']}')
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
