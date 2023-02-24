import 'package:contacta_pharmacy/models/advice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

//TODO da rivedere totalmente

class AdviceDetail extends ConsumerStatefulWidget {
  static const routeName = '/advices-detail';

  const AdviceDetail({Key? key}) : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends ConsumerState<AdviceDetail> {
  Advice? advice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      advice = ModalRoute.of(context)!.settings.arguments as Advice?;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'advice')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: advice == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: advice!.image == null
                          ? Image.asset(
                              'assets/images/noImage.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              advice!.image!,
                              fit: BoxFit.cover,
                            )),
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
                        Flexible(
                          child: Text(
                            advice!.title!,
                            style: const TextStyle(
                                fontSize: 19,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.bold),
                          ),
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
                          advice!.date!,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 190, 190, 190),
                              fontWeight: FontWeight.w400,
                              fontSize: 17),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        // const Icon(
                        //   Icons.access_time,
                        //   color: Color.fromARGB(255, 190, 190, 190),
                        // ),
                        const SizedBox(
                          width: 5,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 15),
                    child: Row(
                      children: [
                        Flexible(
                          child: Html(
                            data: (advice?.description) ?? '',
                          ),
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
