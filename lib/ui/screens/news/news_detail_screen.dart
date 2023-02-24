import 'package:contacta_pharmacy/models/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class NewsDetails extends ConsumerStatefulWidget {
  static const routeName = '/news-detail-screen';

  const NewsDetails({Key? key}) : super(key: key);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends ConsumerState<NewsDetails> {
  News? news;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      news = ModalRoute.of(context)!.settings.arguments as News;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'news')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: news == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: news!.image == null
                        ? Image.asset(
                            'assets/images/noImage.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            news!.image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: ref.read(flavorProvider).lightPrimary,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 40),
                            child: Text(
                              'Info',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 13, right: 10),
                    child: Row(
                      children: [
                        Text(
                          news!.title!,
                          style: const TextStyle(
                              fontSize: 19,
                              color: AppColors.darkGrey,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 13, right: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 190, 190, 190),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          news!.date!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 190, 190),
                              fontWeight: FontWeight.w400,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.access_time,
                          color: Color.fromARGB(255, 190, 190, 190),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          news!.readingTime! +
                              'm ' +
                              translate(context, 'of_reading'),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 190, 190),
                              fontWeight: FontWeight.w400,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 15),
                    child: Column(
                      children: [
                        Html(
                          data: (news!.description!),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50)
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         translate(context, 'website').toUpperCase(),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
