import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pharmacy_banner.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pharmacy_for_you_card.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pharmacy_item.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pharmacy_social_items.dart';
import 'package:contacta_pharmacy/ui/screens/about_us_screen.dart';
import 'package:contacta_pharmacy/ui/screens/advice/advices_screen.dart';
import 'package:contacta_pharmacy/ui/screens/conventions_screen.dart';
import 'package:contacta_pharmacy/ui/screens/notifications/notifications_screen.dart';
import 'package:contacta_pharmacy/ui/screens/our_team.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/contact_screen.dart';
import 'package:contacta_pharmacy/ui/screens/pharmacy/pharmacy_offers_screen.dart';
import 'package:contacta_pharmacy/ui/screens/shifts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';
import '../custom_widgets/badge_notification.dart';
import '../custom_widgets/bottom_sheets/bottom_sheet_hours.dart';
import '../custom_widgets/title_text.dart';
import 'digital_flyers_screen.dart';
import 'news/news_screen.dart';

class PharmacyScreen extends ConsumerWidget {
  const PharmacyScreen({Key? key}) : super(key: key);
  static const routeName = '/pharmacy-screen';

  List<Widget> getWidgets(BuildContext context, Flavor flavor) {
    final List<Widget> widgets = [];

    if (flavor.hasAdvices) {
      widgets.add(PharmacyForYouCard(
        onTap: () {
          Navigator.of(context).pushNamed(AdvicesScreen.routeName);
        },
        icon: Icons.tips_and_updates,
        color: const Color(0xFF5384F6),
        title: translate(context, 'our_advice'),
      ));
    }

    if (flavor.hasNews) {
      widgets.add(PharmacyForYouCard(
        onTap: () {
          Navigator.of(context).pushNamed(NewsScreen.routeName);
        },
        icon: Icons.newspaper,
        color: const Color(0xFF9F87F7),
        title: translate(context, 'the_last_News'),
      ));
    }

    widgets.add(
      PharmacyForYouCard(
        onTap: () {
          Navigator.of(context).pushNamed(ShiftsScreen.routeName);
        },
        icon: Icons.schedule,
        color: const Color(0xFFC386F8),
        title: translate(context, 'discover'),
      ),
    );

    if (flavor.farmaciediturnoCode?.isNotEmpty ?? false) {
      widgets.add(
        PharmacyForYouCard(
          onTap: () {
            launchUrl(
                'https://www.farmaciediturno.org/${flavor.farmaciediturnoCode != null ? "comune.asp?cod=${flavor.farmaciediturnoCode}" : ''}');
          },
          icon: Icons.where_to_vote,
          color: const Color(0xFF19B2A5),
          title: translate(context, 'the_pharmacy'),
        ),
      );
    }

    if (flavor.hasConventions) {
      widgets.add(
        PharmacyForYouCard(
            onTap: () {
              Navigator.of(context).pushNamed(ConventionsScreen.routeName);
            },
            icon: Icons.handshake,
            color: const Color(0xFF02837E),
            title: translate(context, 'conventions')),
      );
    }

    widgets.add(
      PharmacyForYouCard(
        onTap: () {
          Navigator.of(context).pushNamed(OurTeamScreen.routeName);
        },
        icon: Icons.group,
        color: const Color(0xFF3699FF),
        title: translate(context, 'discover_team'),
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.read(flavorProvider);
    final cards = getWidgets(context, flavor);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/flavor/appbar.png',
          height: 32,
        ),
        /*   leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            'assets/icons/ic_menu.png',
            height: 18,
            width: 34,
          ),
        ),*/
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) => const BottomSheetHours());
            },
            child: Icon(
              Icons.watch_later,
              color: ref.read(flavorProvider).lightPrimary,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(NotificationsScreen.routeName);
            },
            child: const BadgeNotifications(),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              const PharmacyBanner(),
              const SizedBox(
                height: 24,
              ),
              TitleText(
                text: translate(context, 'in_evidence'),
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PharmacyItemIcon(
                    onTap: () {
                      Navigator.of(context).pushNamed(ContactScreen.routeName);
                    },
                    imgUrl: Icons.contacts,
                    color: const Color(0xFFC386F8),
                    title: translate(context, 'contacts'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  PharmacyItemIcon(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AboutUsScreen.routeName);
                      },
                      color: const Color(0xFFFFC008),
                      imgUrl: Icons.info,
                      title: translate(context, 'who_we_are')),
                  if (flavor.hasOffers) const SizedBox(width: 20),
                  if (flavor.hasOffers)
                    PharmacyItemIcon(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(PharmacyOffersScreen.routeName);
                      },
                      imgUrl: Icons.campaign,
                      color: const Color(0xFF3E6FF5),
                      title: translate(context, 'offers'),
                    ),
                  if (flavor.hasDigitalFlyer) const SizedBox(width: 20),
                  if (flavor.hasDigitalFlyer)
                    PharmacyItemIcon(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(DigitalFlyersScreen.routeName);
                      },
                      imgUrl: Icons.newspaper,
                      color: const Color(0xFF019C98),
                      title: translate(context, 'valantino_digitale'),
                    ),
                  if (!flavor.hasDigitalFlyer) const SizedBox(width: 20),
                  if (!flavor.hasDigitalFlyer) const Spacer(),
                  if (!flavor.hasOffers) const SizedBox(width: 20),
                  if (!flavor.hasOffers) const Spacer(),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TitleText(
                text: translate(context, 'think_of_self'),
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 16,
              ),
              AlignedGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemBuilder: (context, index) {
                  return cards[index];
                },
              ),
              // Row(
              //   children: [
              //     Expanded(child: cards[0]),
              //     const SizedBox(width: 16),
              //     Expanded(child: cards[1]),
              //   ],
              // ),
              // if (cards.length > 2) const SizedBox(height: 16),
              // if (cards.length > 2)
              //   Row(
              //     children: [
              //       Expanded(child: cards[2]),
              //       const SizedBox(width: 16),
              //       Expanded(
              //         child:
              //             cards.length > 3 ? cards[3] : const SizedBox.shrink(),
              //       ),
              //     ],
              //   ),
              // if (cards.length > 4) const SizedBox(height: 16),
              // if (cards.length > 4)
              //   Row(
              //     children: [
              //       Expanded(child: cards[4]),
              //       const SizedBox(width: 16),
              //       Expanded(
              //         child:
              //             cards.length > 5 ? cards[5] : const SizedBox.shrink(),
              //       ),
              //     ],
              //   ),

              const SizedBox(
                height: 32,
              ),
              TitleText(
                text: translate(context, 'follow_contact'),
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 16,
              ),
              const PharmacySocialItems(),
              /*   const SizedBox(
                height: 16,
              ),
              TitleText(
                text: translate(context, 'discover_features'),
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
              ),*/
              /*      const SizedBox(
                height: 16,
              ),
              InnovationItem(
                imgUrl: 'assets/images/running_out.png',
                title: translate(context, 'telemedicine'),
                body: translate(context,Constant.isParaPharmacy? 'telemedicine_des_parapharmacy' : 'telemedicine_des_pharmacy'),
                onTap: () {},
              ),
              const SizedBox(
                height: 16,
              ), */
              //TODO finire
              /*    InnovationItem(
                  title: translate(context, 'pharmacash'),
                  body: translate(context, 'pharmacash_des'),
                  imgUrl: '',
                  onTap: () {}),*/
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InnovationItem extends StatelessWidget {
  const InnovationItem({
    Key? key,
    required this.title,
    required this.body,
    required this.imgUrl,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String body;
  final String imgUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              color: Colors.grey.withOpacity(0.1),
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imgUrl),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.h6Style.copyWith(
                        fontWeight: FontWeight.w600, color: AppColors.darkGrey),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    body,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.h6Style.copyWith(fontSize: 8.0.sp),
                    maxLines: 7,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
