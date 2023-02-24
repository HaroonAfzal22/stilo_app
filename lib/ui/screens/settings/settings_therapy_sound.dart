import 'package:contacta_pharmacy/theme/app_colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../config/preference_utils.dart';
import '../../../models/flavor.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class SettingsTherapySoundScreen extends ConsumerStatefulWidget {
  const SettingsTherapySoundScreen({Key? key}) : super(key: key);
  static const routeName = '/settings-therapy-sound-screen';

  @override
  ConsumerState<SettingsTherapySoundScreen> createState() =>
      _SettingsTherapySoundScreenState();
}

class _SettingsTherapySoundScreenState
    extends ConsumerState<SettingsTherapySoundScreen> {
  final ExpandableController _controller = ExpandableController();
  int group = PreferenceUtils.getString("therapy_sound") == "spring" ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'therapy',
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                    hasIcon: false,
                    tapBodyToCollapse: true,
                    tapHeaderToExpand: true,
                    tapBodyToExpand: true),
                collapsed: const SizedBox(),
                header: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    color: ref.read(flavorProvider).primary,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(context, 'choose_therapy_ringtone'),
                          style: AppTheme.h3Style.copyWith(
                              fontSize: 12.0.sp, color: AppColors.white),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.white,
                        )
                      ],
                    ),
                  ),
                ),
                controller: _controller,
                expanded: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Spring Sound",
                        style: AppTheme.h3Style.copyWith(fontSize: 10.0.sp),
                      ),
                      trailing: Radio(
                        activeColor: ref.read(flavorProvider).primary,
                        value: 1,
                        groupValue: group,
                        onChanged: (v) async {
                          //   setState(() {
                          //     group = v;
                          //   });

                          //   if (Platform.isIOS) {
                          //     PreferenceUtils.setString(
                          //         "therapy_sound", "slow_spring_board.aiff");
                          //   } else {
                          //     PreferenceUtils.setString("therapy_sound", "alert");
                          //   }

                          //   await flutterLocalNotificationsPlugin.cancelAll();
                          //   reInitNotification(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        )));
  }
}
