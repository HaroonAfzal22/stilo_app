import 'package:contacta_pharmacy/models/medcab_item.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/bottom_sheets/bottom_sheet_prescription.dart';
import 'package:contacta_pharmacy/ui/screens/medcab/medcab_edit_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/medcab/insert_product_medcab.dart';

class MedCabItemListTile extends StatefulWidget {
  const MedCabItemListTile({
    Key? key,
    required this.medCabItem,
  }) : super(key: key);
  final MedCabItem medCabItem;

  @override
  State<MedCabItemListTile> createState() => _MedCabItemListTileState();
}

class _MedCabItemListTileState extends State<MedCabItemListTile> {
  bool isExpired = false;
  bool isFinishing = false;
  bool isExpiring = false;
  DateTime? date;

  void calculateLabels() {
    if (widget.medCabItem.expirationDate != null) {
      var inputFormat = DateFormat('dd/MM/yyyy');
      var date1 = inputFormat.parse(widget.medCabItem.expirationDate!);
      var outputFormat = DateFormat('yyyy-MM-dd');
      var date2 = outputFormat.format(date1);
      date = DateTime.tryParse(date2);
      if (date != null) {
        if (date!.isBefore(DateTime.now())) {
          isExpired = true;
        } else if (date!
            .isBefore(DateTime.now().add(const Duration(days: 10)))) {
          isExpiring = true;
        }
      }
    }
    if (widget.medCabItem.qty != null && widget.medCabItem.limit != null) {
      if (int.parse(widget.medCabItem.qty) <
          int.parse(widget.medCabItem.limit)) {
        isFinishing = true;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isExpired = false;
    isFinishing = false;
    isExpiring = false;
    calculateLabels();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EditProductMedCab.routeName,
            arguments: widget.medCabItem);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/images/noImage.png",
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.medCabItem.name ?? 'Prodotto medcab'),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(widget.medCabItem.expirationDate ??
                              'Nessuna data inserita'),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('Quantità: ${widget.medCabItem.qty ?? 'N/D'}'),
                        ],
                      ),
                      Column(
                        children: [
                          if (isExpired)
                            const Label(
                              title: 'Scaduto',
                              backgroundColor: Colors.red,
                            ),
                          if (isExpiring)
                            const Label(
                              title: 'Sta scadendo',
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                          if (isFinishing)
                            const Label(
                              title: 'Sta finendo',
                              backgroundColor: Colors.deepOrange,
                            ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  const Label({
    required this.title,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
