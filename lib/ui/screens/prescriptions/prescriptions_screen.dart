import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/screens/prescriptions/prescription_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/flavor.dart';
import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';
import '../../custom_widgets/no_data.dart';
import '../../custom_widgets/no_user.dart';

class PrescriptionScreen extends ConsumerStatefulWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);
  static const routeName = 'prescriptions_screen';

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends ConsumerState<PrescriptionScreen> {
  List<dynamic>? prescriptions;
  final ApisNew _apisNew = ApisNew();

  Future<void> getPrescriptions() async {
    final result = await _apisNew.getAllPrescriptions({
      'user_id': ref.read(authProvider).user?.userId,
    });
    prescriptions = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user != null) {
      getPrescriptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'the_recipe_loaded'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              if (user == null)
                const NoUser()
              else if (prescriptions != null && prescriptions!.isNotEmpty)
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PrescriptionDetailScreen.routeName,
                                    arguments: prescriptions![index]);
                              },
                              leading: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.purple.withOpacity(0.85),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(13.0),
                                    child: Icon(
                                      Icons.upload_file,
                                      color: Colors.white,
                                    ),
                                  )),
                              title: Text(
                                  //translate
                                  translate(context, "recipe_uploaded") +
                                      " " +
                                      DateFormat("dd MMMM yyyy HH:mm:ss", 'it')
                                          .format(DateFormat(
                                        "yyyy-MM-dd HH:mm:ss",
                                      ).parse(prescriptions![index]
                                              ['created_date']))),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                    itemCount: prescriptions!.length)
              else if (prescriptions != null && prescriptions!.isEmpty)
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 120),
                  child: const NoData(),
                )
              else if (prescriptions == null)
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2 - 100),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ref.read(flavorProvider).lightPrimary,
                    ),
                  ),
                ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
