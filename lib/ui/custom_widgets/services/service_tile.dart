import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/screens/services/service_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';

class ServiceTile extends ConsumerWidget {
  const ServiceTile({
    Key? key,
    required this.service,
  }) : super(key: key);

  final dynamic service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              //TODO add if
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: service['image'] == null
                    ? Image.asset(
                        "assets/images/service_placeholder.jpeg",
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: service['image'],
                        errorWidget: (context, url, error) {
                          return Image.asset(
                              "assets/images/service_placeholder.jpeg");
                        },
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                  child: Text(
                    service['price'] != null
                        ? NumberFormat.currency(locale: 'it_IT', symbol: '€')
                            .format(double.tryParse(service['price']))
                        : 'N/D',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ]),
            const SizedBox(
              height: 12,
            ),
            Text(
              service['title'],
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              service['desc'] ?? '',
              style: TextStyle(color: AppColors.lightGrey, fontSize: 12.0.sp),
            ),
            const SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ServiceDetailScreen.routeName,
                    arguments: service);
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                      'discover_the_service',
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
          ],
        ),
      ),
    );
  }
}
