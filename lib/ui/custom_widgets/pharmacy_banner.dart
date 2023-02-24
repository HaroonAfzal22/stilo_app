import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/site_provider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';

class PharmacyBannerPlaceholder extends ConsumerWidget {
  const PharmacyBannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 80),
          decoration: BoxDecoration(
            color: ref.read(flavorProvider).lightPrimary,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: const Center(
            child: Text(
              'Il tuo logo qui',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        DotsIndicator(dotsCount: 1),
      ],
    );
  }
}

class PharmacyBanner extends ConsumerStatefulWidget {
  const PharmacyBanner({Key? key}) : super(key: key);

  @override
  PharmacyBannerState createState() => PharmacyBannerState();
}

class PharmacyBannerState extends ConsumerState<PharmacyBanner> {
  List<dynamic>? bannerList;
  final ApisNew _apisNew = ApisNew();
  final CarouselController _carouselController = CarouselController();
  double? currentIndex;

  Future<void> getBannerList() async {
    final sedeId = ref.read(siteProvider);
    final result = await _apisNew.getBannerList({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'sede_id': ref.read(siteProvider)!.id,
    });
    bannerList = result.data['banner_data'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBannerList();
  }

  @override
  Widget build(BuildContext context) {
    if (bannerList == null || bannerList!.isEmpty) {
      return const SizedBox();
    } else {
      return bannerList != null
          ? Column(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    onScrolled: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    height: 200.0,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                  ),
                  items: bannerList?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(),
                                  imageUrl: i['image'],
                                  fit: BoxFit.cover,
                                  height: 180,
                                ),
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (bannerList != null)
                  DotsIndicator(
                    position: currentIndex ?? 0,
                    dotsCount: bannerList!.length,
                    decorator: DotsDecorator(
                      activeColor: ref.read(flavorProvider).lightPrimary,
                    ),
                  )
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: ref.read(flavorProvider).primary,
              ),
            );
    }
  }
}
