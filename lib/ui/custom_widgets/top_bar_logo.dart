import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/flavor.dart';

class TopBarLogo extends ConsumerWidget {
  const TopBarLogo({Key? key}) : super(key: key);

  Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = ref.read(flavorProvider).primary;
    final light = ref.read(flavorProvider).lightPrimary;

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              top: (MediaQuery.of(context).size.width * 60 / 100) -
                  (MediaQuery.of(context).size.width / 3 / 2),
              child: Center(
                child: Image.asset(
                  'assets/flavor/launcher_icon.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 3,
                ),
              ),
            ),
            Column(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_mask1.svg',
                  width: MediaQuery.of(context).size.width,
                  color: primary,
                ),
                const SizedBox(height: 64),
              ],
            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/ic_mask2.svg',
                width: MediaQuery.of(context).size.width * 90 / 100,
                color: light == primary ? lighten(primary, 50) : light,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
