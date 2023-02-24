import 'package:contacta_pharmacy/models/medcab_item.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/med_cab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class EditProductMedCab extends ConsumerStatefulWidget {
  const EditProductMedCab({Key? key}) : super(key: key);
  static const routeName = '/edit-product-medcab';

  @override
  _EditProductMedCabState createState() => _EditProductMedCabState();
}

class _EditProductMedCabState extends ConsumerState<EditProductMedCab> {
  MedCabItem? args;
  DateTime? pickedDate;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _controllers = {
    'name': TextEditingController(),
    'expiration_date': TextEditingController(),
    'qty': TextEditingController(),
    'notes': TextEditingController(),
    'limit': TextEditingController(),
  };

  initArgs() {
    _controllers['name'].text = args?.name;
    _controllers['expiration_date'].text = args?.expirationDate ?? '';
    _controllers['qty'].text = args?.qty == null ? "" : args?.qty?.toString();
    _controllers['notes'].text = args?.notes ?? '';
    _controllers['limit'].text =
        args?.limit == null ? "" : args?.limit?.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      args = ModalRoute.of(context)!.settings.arguments as MedCabItem;
      initArgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO translation
        title: const Text('Modifica prodotto'),
        actions: [
          IconButton(
            onPressed: () async {
              ref.read(medCabProvider).deleteMedCabItem({
                "med_cab_id": args?.id,
                "user_id": ref.read(authProvider).user?.userId
              });
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.delete,
              color: AppColors.darkRed,
            ),
          )
        ],
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
                    labelText: translate(context, 'product_name'),
                    //hintText: translate(context, 'product_name'),
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
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 90)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 720)));

                    if (pickedDate != null) {
                      setState(() {
                        _controllers['expiration_date'].text =
                            formatter.format(pickedDate!);
                      });
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
                  height: 16,
                ),
                TextFormField(
                  controller: _controllers['qty'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    //hintText: translate(context, 'Quantity'),
                    labelText: translate(context, 'Quantity'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllers['notes'],
                  decoration: InputDecoration(
                    //hintText: translate(context, 'INDICATIONS_NOTES'),
                    labelText: translate(context, 'INDICATIONS_NOTES'),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllers['limit'],
                  decoration: InputDecoration(
                    //hintText: translate(context, 'limit_number'),
                    labelText: translate(context, 'limit_number'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () async {
                    final result =
                        await ref.read(medCabProvider).updateMedCabItem({
                      "med_cab_id": args?.id,
                      "user_id": ref.read(authProvider).user?.userId,
                      "name": _controllers['name'].text,
                      "expirationDate": _controllers['expiration_date'].text,
                      "qty": _controllers['qty'].text,
                      "notes": _controllers['notes'].text,
                      "limit": _controllers['limit'].text,
                      "productId": null
                    });
                    Navigator.of(context).pop();
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
