import 'package:contacta_pharmacy/ui/custom_widgets/home_item.dart';
import 'package:contacta_pharmacy/ui/screens/services/aesthetic_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/events/events_screen.dart';
import 'package:contacta_pharmacy/ui/screens/services/general_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/medical_analyst_services.dart';
import 'package:contacta_pharmacy/ui/screens/services/service_web_view.dart';
import 'package:contacta_pharmacy/ui/screens/services/videocall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/title_text.dart';
import 'covid19_services.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  static const routeName = '/services-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.read(flavorProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'services'),
          style: TextStyle(color: ref.read(flavorProvider).primary),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: TitleText(
                  text: translate(context, 'service_heading'),
                  color: AppColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: TitleText(
                  text: translate(context, 'service_heading_des'),
                  color: AppColors.black,
                  fontSize: 10.0.sp,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 32,
              ),

              ItemTileIconWithBackground(
                title: "Prenotazioni",
                text:
                    "Prenota un servizio attraverso il portale di Farmacie Stilo",
                image: Icons.launch,
                color: flavor.lightPrimary,
                onTap: () {
                  Navigator.of(context).pushNamed(ServicesWebView.routeName);
                },
              ),

              // ItemTileIconWithBackground(
              //   title: "Video Call",
              //   text: "Prenota un servizio attraverso ",
              //   image: Icons.format_list_bulleted,
              //   color: const Color(0xFF5384F6),
              //   onTap: () {
              //     Navigator.of(context).pushNamed(VideoCallPage.routeName);
              //   },
              // ),
              ItemTileIconWithBackground(
                title: translate(context, 'service_general'),
                text: translate(context, 'service_general_des'),
                image: Icons.format_list_bulleted,
                color: const Color(0xFF5384F6),
                onTap: () {
                  Navigator.of(context).pushNamed(GeneralServices.routeName);
                },
              ),
              // if (flavor.hasAesthetic)
              //   const SizedBox(
              //     height: 16,
              //   ),
              // if (flavor.hasAesthetic)
              //   ItemTileSVGWithBackground(
              //     title: translate(context, 'service_aesthetic'),
              //     text: translate(
              //         context,
              //         ref.read(flavorProvider).isParapharmacy
              //             ? 'service_aesthetic_des_parapharmacy'
              //             : 'service_aesthetic_des_pharmacy'),
              //     image: 'assets/images/cabina_estetica.svg',
              //     color: const Color(0xFFF4B961),
              //     onTap: () {
              //       Navigator.of(context)
              //           .pushNamed(AestheticServices.routeName);
              //     },
              //   ),
              // if (flavor.hasCovid19 && !flavor.isParapharmacy)
              //   const SizedBox(
              //     height: 16,
              //   ),
              // if (flavor.hasCovid19 && !flavor.isParapharmacy)
              //   ItemTileIconWithBackground(
              //     title: translate(context, 'service_covid'),
              //     text: translate(context, 'service_covid_des'),
              //     image: Icons.coronavirus,
              //     color: const Color(0xFFEF7F5E),
              //     onTap: () {
              //       Navigator.of(context).pushNamed(Covid19Services.routeName);
              //     },
              //   ),
              // if (flavor.hasAnalysis)
              //   const SizedBox(
              //     height: 16,
              //   ),
              // if (flavor.hasAnalysis)
              //   ItemTileIconWithBackground(
              //     title: translate(context, 'service_medical_analyz'),
              //     text: translate(context, 'service_medical_analyz_des'),
              //     image: Icons.bloodtype,
              //     color: const Color(0xFF5384F6),
              //     onTap: () {
              //       Navigator.of(context)
              //           .pushNamed(MedicalAnalystServices.routeName);
              //     },
              //   ),
              // if (flavor.hasEvents)
              //   const SizedBox(
              //     height: 16,
              //   ),
              // if (flavor.hasEvents)
              //   ItemTileIconWithBackground(
              //     title: translate(context, 'service_event'),
              //     text: translate(
              //         context,
              //         ref.read(flavorProvider).isParapharmacy
              //             ? 'service_event_des_parapharmacy'
              //             : 'service_event_des_pharmacy'),
              //     image: Icons.event,
              //     color: const Color(0xFFF4B961),
              //     onTap: () {
              //       Navigator.of(context).pushNamed(EventsScreen.routeName);
              //     },
              //   ),
              //TODO riattivare dopo
              /*  const SizedBox(
                height: 16,
              ),
              ItemTilePNG(
                title: translate(context, 'service_rental'),
                text: translate(
                    context,
                    Constant.isParaPharmacy
                        ? 'service_rental_des_parapharmacy'
                        : 'service_rental_des_pharmacy'),
                imgUrl: 'assets/images/ic_service_rental.png',
                onTap: () {
                  Navigator.of(context).pushNamed(RentalProducts.routeName);
                },
              ), */
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
