import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/news.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';
import 'news_detail_screen.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);
  static const routeName = '/news-screen';

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  List<News>? newsData;
  int pageNum = 0;
  final ApisNew _apisNew = ApisNew();

  Future<void> getNews() async {
    final result = await _apisNew.getNews(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );
    setState(() {
      newsData = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          translate(context, 'news'),
        ),
      ),
      body: SingleChildScrollView(
        child: newsData == null
            ? Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              )
            : newsData != null && newsData!.isEmpty
                ? NoData(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2 - 100),
                    text: translate(
                        context,
                        ref.read(flavorProvider).isParapharmacy
                            ? "No_News_parapharmacy"
                            : "No_News_pharmacy"))
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(context, "the_latest_news_from_pharmacy"),
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 15.0.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${translate(context, "there_are")} ${newsData!.length} ${translate(context, "items_available")}",
                          style: TextStyle(
                            color: AppColors.lightGrey.withOpacity(0.7),
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: newsData!.length,
                            itemBuilder: (context, index) {
                              return NewsItem(news: newsData![index]);
                            }),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class NewsItem extends ConsumerWidget {
  const NewsItem({Key? key, required this.news}) : super(key: key);
  final News news;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(NewsDetails.routeName, arguments: news);
        // NewsDetails(
        //     data: news,
        //     newsData: news,
        //   ),
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: ref.read(flavorProvider).lightPrimary.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 3)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 9.0.h,
                    width: 10.0.h,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                news.image ?? "asstes/images/noimage.png"),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 8,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Consumer(builder: (context, ref, _) {
                            return Text(
                              news.title!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ref.read(flavorProvider).primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0.sp,
                              ),
                            );
                          }),
                        ),

                        /*       Html(
                                          data:
                                          "${newsData[index]['description'].toString().substring(0, newsData[index]['description'].toString().length > 70 ? 70 : newsData[index]['description'].toString().length)} ${newsData[index]['description'].toString().length > 70 ? "..." : ""}",
                                          shrinkWrap: true,
                                          onLinkTap: (String url,
                                              RenderContext context,
                                              Map<String, String> attributes,
                                              dom.Element element) {
                                            launchUrl(url);
                                            //open URL in webview, or launch URL in browser, or any other logic here
                                          }),*/

                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, top: 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
