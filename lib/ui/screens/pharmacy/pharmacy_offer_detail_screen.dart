import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../utils/ImageString.dart';

class PharmacyOfferDetail extends StatefulWidget {
  const PharmacyOfferDetail({Key? key}) : super(key: key);
  static const routeName = '/pharmacy-offer-detail';

  @override
  State<PharmacyOfferDetail> createState() => _PharmacyOfferDetailState();
}

class _PharmacyOfferDetailState extends State<PharmacyOfferDetail> {
  dynamic offer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      offer = ModalRoute.of(context)!.settings.arguments as dynamic;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'offers'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (offer != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    if (offer['image'] != null)
                      Center(
                        child: Image.network(
                          offer['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 10),
                      child: Text(
                        '${offer['title']}',
                        style: AppTheme.h5Style.copyWith(
                            fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                ic_date,
                                height: 2.0.h,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${translate(context, "Posted_on")} ${DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(offer['date']))}",
                                // 'Posted on ${data['date']}',
                                style: AppTheme.bodyText
                                    .copyWith(color: AppColors.lightGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Html(
                      data: offer['description'],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
