import 'package:contacta_pharmacy/ui/custom_widgets/bottom_sheets/bottom_sheet_add_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class SettingsAddCard extends ConsumerStatefulWidget {
  const SettingsAddCard({Key? key}) : super(key: key);
  static const routeName = '/settings-add-card';

  @override
  ConsumerState<SettingsAddCard> createState() => _SettingsAddCardState();
}

class _SettingsAddCardState extends ConsumerState<SettingsAddCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'add_card'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.72,
              child: ListView.builder(
                  //itemCount: model.cardListing.length,
                  itemCount: 0,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.all(5.0),
                      // child: _list(model, index),
                      child: Text("ciao"),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, bottom: 10, top: 30),
                width: 60.0.w,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    showModalBottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) => AddCardBottomSheet(),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0.h),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1.6.h),
                        decoration: BoxDecoration(
                          color: ref.read(flavorProvider).lightPrimary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              translate(context, "add_card"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
