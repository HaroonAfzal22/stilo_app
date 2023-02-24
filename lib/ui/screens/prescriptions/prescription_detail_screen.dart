import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  const PrescriptionDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/prescription-detail-screen';

  @override
  State<PrescriptionDetailScreen> createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  dynamic prescription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      prescription = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
      ),
      body: prescription != null
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: prescription['images'] == null
                            ? Image.asset(
                                'assets/images/noImage.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                prescription['images'],
                                fit: BoxFit.cover,
                              )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14, left: 0, right: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: AppColors.purple.withOpacity(0.85),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 40),
                          child: Text(
                            translate(context, "recipe"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (prescription['created_date'] != null)
                      Text(
                        'Caricata il : ${DateFormat("dd MMMM yyyy HH:mm:ss", 'it').format(DateFormat(
                          "yyyy-MM-dd HH:mm:ss",
                        ).parse(prescription!['created_date']))}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 52, 52, 52),
                            fontWeight: FontWeight.w400,
                            fontSize: 17),
                      ),
                    if (prescription['drug_preference'] != null)
                      Text(
                          '${translate(context, "preference")} ${prescription['drug_preference']}'),
                    if (prescription['type'] != null)
                      Text(
                          '${translate(context, "tipo")}: ${prescription['type'] == 'Medical' ? translate(context, "medical") : translate(context, "veterinary")}'),
                    if (prescription['cadico_tax'] != null)
                      Text('Codice Fiscale: ${prescription['cadico_tax']}'),
                    if (prescription['recipe_pin'] != null)
                      Text('PIN: ${prescription['recipe_pin']}'),
                    if (prescription['number'] != null)
                      Text('Numero: ${prescription['number']}'),
                    if (prescription['notes'] != null)
                      Text('Note: ${prescription['notes']}')
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
