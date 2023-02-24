import 'package:contacta_pharmacy/ui/screens/login/pre_login_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../translations/translate_string.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static const routeName = '/onboarding';

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  late final List<Map<String, dynamic>> list;
  int index = 0;
  int itemCount = 3;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    list = [
      {
        "title": ref.read(flavorProvider).isParapharmacy
            ? "onboarding_first_title_parapharmacy"
            : "onboarding_first_title_pharmacy",
        "body": ref.read(flavorProvider).isParapharmacy
            ? 'onboarding_first_parapharmacy'
            : 'onboarding_first_pharmacy',
        "image": "assets/images/ic_intro1.png"
      },
      {
        "title": "onboarding_second_title",
        "body": "onboarding_second",
        "image": "assets/images/ic_intro2.png"
      },
      {
        "title": "onboarding_third_title",
        "body": ref.read(flavorProvider).isParapharmacy
            ? "onboarding_third_parapharmacy"
            : "onboarding_third_pharmacy",
        "image": "assets/images/ic_intro3.png"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) => Column(
                  children: [
                    Expanded(flex: 8, child: Image.asset(list[index]['image'])),
                    Text(translate(context, list[index]['title']),
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: ref.read(flavorProvider).primary,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      translate(context, list[index]['body']),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xff7C7D7E),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    index = page;
                  });
                },
                itemCount: itemCount,
              ),
            ),
            DotsIndicator(
              onTap: (tappedIndex) {
                setState(() {
                  index = tappedIndex.toInt();
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                });
              },
              dotsCount: itemCount,
              position: index.toDouble(),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const PreLoginScreen()),
                    (route) => false);
              },
              child: Text(
                translate(context, "skip_intro"),
                style: TextStyle(
                    color: ref.read(flavorProvider).primary, fontSize: 16.0.sp),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
