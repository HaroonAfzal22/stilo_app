import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/flavor.dart';
import '../../translations/translate_string.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  static const routeName = '/about-us-screen';

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  dynamic data;

  final ApisNew _apisNew = ApisNew();

  Future<void> getAboutUsData() async {
    final result = await _apisNew.cms({
      'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      'slug': 'AboutUs',
    });
    data = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAboutUsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translate(context, 'who_we_are'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: data != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  data['image_about_us'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 6, right: 6),
                          child: SizedBox(
                            child: CachedNetworkImage(
                              imageUrl: data['image_about_us'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data['about_us_title'] ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Html(
                      data: data['about_us_description'],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: ref.read(flavorProvider).lightPrimary,
                ),
              ),
            ),
    );
  }
}
