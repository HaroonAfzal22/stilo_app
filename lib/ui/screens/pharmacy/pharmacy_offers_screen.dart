import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/pharmacy_offer_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';

class PharmacyOffersScreen extends ConsumerStatefulWidget {
  const PharmacyOffersScreen({Key? key}) : super(key: key);
  static const routeName = '/pharmacy-offers-screen';

  @override
  ConsumerState<PharmacyOffersScreen> createState() =>
      _PharmacyOffersScreenState();
}

class _PharmacyOffersScreenState extends ConsumerState<PharmacyOffersScreen> {
  List<dynamic>? offers;
  final ApisNew _apisNew = ApisNew();

  Future<void> getOffers() async {
    final result = await _apisNew.getOffers(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );

    offers = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'Offers'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              if (offers != null && offers!.isNotEmpty)
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        OfferItem(offer: offers![index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: offers!.length)
              else if (offers != null && offers!.isEmpty)
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: const NoData(),
                )
              else
                Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class OfferItem extends ConsumerWidget {
  const OfferItem({Key? key, required this.offer}) : super(key: key);
  final dynamic offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.0.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              image: DecorationImage(
                  image: NetworkImage('${offer['image']}'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10),
            child: Text(
              '${offer['title']}',
              style: AppTheme.h5Style
                  .copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
            ),
          ),
          //TODO fix
          /*     SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Html(
                  data:
                      """${offersList[index]['description'].toString().substring(0, offersList[index]['description'].toString().length >= 100 ? 100 : offersList[index]['description'].toString().length)}""",
                  onLinkTap: (String url, RenderContext context,
                      Map<String, String> attributes, dom.Element element) {
                    launchUrl(url);
                    //open URL in webview, or launch URL in browser, or any other logic here
                  }),
            ),
          ),*/
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PharmacyOfferDetail.routeName, arguments: offer);
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ref.read(flavorProvider).lightPrimary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  translate(
                    context,
                    'read_more',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
