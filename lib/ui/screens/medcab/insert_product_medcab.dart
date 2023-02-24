import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/med_cab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class InsertProductMedCab extends ConsumerStatefulWidget {
  const InsertProductMedCab({Key? key}) : super(key: key);
  static const routeName = '/insert-product-medcab';

  @override
  _InsertProductMedCabState createState() => _InsertProductMedCabState();
}

class _InsertProductMedCabState extends ConsumerState<InsertProductMedCab> {
  final ApisNew _apisNew = ApisNew();
  DateTime? pickedDate;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'expiration_date': TextEditingController(),
    'qty': TextEditingController(),
    'notes': TextEditingController(),
    'limit': TextEditingController(),
  };

  void createMedCabItem() {
    ref.read(medCabProvider).createMedCabItem(
      {
        'user_id': ref.read(authProvider).user?.userId,
        'name': _controllers['name'].text,
        'expirationDate': _controllers['expiration_date'].text,
        'qty': int.tryParse(_controllers['qty'].text),
        'limit': int.tryParse(_controllers['limit'].text)
      },
    );
    Navigator.of(context).pop();
  }

  bool validation() {
    if (_controllers['name'].text.isEmpty) {
      showredToast(translate(context, "err_prodName"), context);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        //TODO edit mode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO translation
        title: const Text('Inserisci prodotto'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllers['name'],
                  decoration: InputDecoration(
                    labelText: 'Nome prodotto',
                    //hintText: translate(context, 'product_name_required'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  onTap: () async {
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 90)),
                        lastDate: DateTime.now().add(Duration(days: 720)));
                    if (pickedDate != null) {
                      _controllers['expiration_date'].text =
                          formatter.format(pickedDate!);
                      setState(() {});
                    }
                  },
                  keyboardType: TextInputType.datetime,
                  controller: _controllers['expiration_date'],
                  decoration: InputDecoration(
                    hintText: translate(context, 'Deadline'),
                    helperText: 'Inserire una data nel formato GG/MM/AAAA',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _controllers['qty'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantità',
                    //hintText: translate(context, 'Quantity'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllers['notes'],
                  decoration: InputDecoration(
                    labelText: 'Note',
                    //hintText: translate(context, 'INDICATIONS_NOTES'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllers['limit'],
                  decoration: InputDecoration(
                    labelText: 'Soglia disponibilità minima',
                    //hintText: translate(context, 'limit_number'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    if (validation()) {
                      createMedCabItem();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ref.read(flavorProvider).lightPrimary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: const Center(
                      child: Text(
                        'Salva',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
