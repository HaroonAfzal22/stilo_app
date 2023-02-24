import 'package:contacta_pharmacy/ui/custom_widgets/icon_standard/standard_icon.dart';
import 'package:contacta_pharmacy/ui/screens/about_us_screen.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advices_screen.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/therapies_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';
import '../screens/services/covid19_services.dart';

class HomeFeaturesList extends StatelessWidget {
  const HomeFeaturesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              //TODO fix
              print('per il momento disattivato');
              // Navigator.of(context).pushNamed(
              //   TherapiesScreen.routeName,
              // );
            },
            child: Column(
              children: [
                SizedBox(
                  child: SvgPicture.asset('assets/images/ic_therapies.svg'),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  translate(context, "Therapies"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 10.0.sp,
                    color: const Color(0xff454545),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AboutUsScreen.routeName);
            },
            child: Column(
              children: [
                SizedBox(
                  child: SvgPicture.asset('assets/images/ic_who_we_are.svg'),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  translate(context, "who_we_are"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 10.0.sp,
                    color: const Color(0xff454545),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AdvicesScreen.routeName);
            },
            child: Column(
              children: [
                SizedBox(
                  child: SvgPicture.asset('assets/images/ic_advice.svg'),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  translate(context, "advice"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 10.0.sp,
                    color: const Color(0xff454545),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              //TODO fix
              print('per il momento disattivato');
              //Navigator.of(context).pushNamed(Covid19Screen.routeName);
            },
            child: Column(
              children: [
                SizedBox(
                  child: SvgPicture.asset('assets/images/ic_covid_19.svg'),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  translate(context, "covid_19"),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 10.0.sp,
                    color: const Color(0xff454545),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeFeaturesListNewIcons extends ConsumerWidget {
  const HomeFeaturesListNewIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.read(flavorProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: IconStandard(
              onTap: () {
                Navigator.of(context).pushNamed(TherapiesScreen.routeName);
              },
              icon: Icons.medication,
              backgroundColor: AppColors.purple,
              text: translate(context, "Therapies"),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: IconStandard(
              onTap: () {
                Navigator.of(context).pushNamed(AboutUsScreen.routeName);
              },
              icon: Icons.info,
              backgroundColor: AppColors.yellow,
              text: translate(context, "who_we_are"),
            ),
          ),
          if (flavor.hasAdvices) const SizedBox(width: 20),
          if (flavor.hasAdvices)
            Expanded(
              child: IconStandard(
                onTap: () {
                  Navigator.of(context).pushNamed(AdvicesScreen.routeName);
                },
                icon: Icons.tips_and_updates,
                backgroundColor: Colors.blue,
                text: translate(context, "advice"),
              ),
            ),
          if (flavor.hasCovid19 && !flavor.isParapharmacy)
            const SizedBox(
              width: 20,
            ),
          if (flavor.hasCovid19 && !flavor.isParapharmacy)
            Expanded(
              child: IconStandard(
                onTap: () {
                  Navigator.of(context).pushNamed(Covid19Services.routeName);
                },
                icon: Icons.coronavirus,
                backgroundColor: Colors.deepOrangeAccent,
                text: translate(context, "covid_19"),
              ),
            ),
          if (!flavor.hasAdvices) const SizedBox(width: 20),
          if (!flavor.hasAdvices) const Spacer(),
          if (!flavor.hasCovid19 || flavor.isParapharmacy)
            const SizedBox(width: 20),
          if (!flavor.hasCovid19 || flavor.isParapharmacy) const Spacer(),
        ],
      ),
    );
  }
}
