///ADERENZA TERAPEUTICA
///
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/therapies_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/buttons/standard_button.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_data.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/pills/pill_tile.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/therapies/therapy_tile.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/title_text.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/create_therapy_first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/therapy.dart';
import '../../../translations/translate_string.dart';

class TherapiesScreen extends ConsumerStatefulWidget {
  const TherapiesScreen({Key? key}) : super(key: key);
  static const routeName = '/therapies-screen';

  @override
  _TherapiesScreenState createState() => _TherapiesScreenState();
}

class _TherapiesScreenState extends ConsumerState<TherapiesScreen> {
  final ApisNew _apisNew = ApisNew();
  int pageNum = 0;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(therapiesProvider).getTherapies({
        'user_id': ref.read(authProvider).user!.userId,
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      });
      ref.read(therapiesProvider).getNextPills(
        {
          'user_id': ref.read(authProvider).user?.userId,
          'page_number': pageNum,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    List<Therapy>? therapies = ref.watch(therapiesProvider).therapies;
    List<dynamic>? nextPills = ref.watch(therapiesProvider).nextPills;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        child: const Icon(
          Icons.add,
          size: 32,
        ),
        onPressed: () {
          if (user != null) {
            Navigator.of(context).pushNamed(CreateTherapyFirstScreen.routeName);
          }
        },
      ),
      appBar: AppBar(
        title: Text(
          translate(context, 'Therapies'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
/*
            TableCalendar(
              calendarFormat: CalendarFormat.week,
              headerVisible: false,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.0.sp),
                  weekdayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8.0.sp,
                      color: AppColors.black)),
              calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: ref.read(flavorProvider).lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: ref.read(flavorProvider).lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                      fontSize: 8.0.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                  weekendTextStyle:
                      TextStyle(color: AppColors.black, fontSize: 11.0.sp)),
              focusedDay: DateTime.now(),
              onDaySelected: (selectedDay, focusedDay) {},
              selectedDayPredicate: (day) {
                return isSameDay(DateTime.now(), day);
              },
            ),
*/
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TitleText(
                color: Colors.black,
                text: translate(context, 'Therapies'),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 8),
            if (therapies != null && user != null && therapies.isNotEmpty)
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 24,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shrinkWrap: true,
                itemCount: therapies.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => TherapyTile(
                  therapy: therapies[index],
                ),
              )
            else if (therapies != null && user != null && therapies.isEmpty)
              const NoData(
                text: 'Non hai inserito terapie',
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TitleText(
                color: Colors.black,
                text: translate(context, 'upcoming_drugs'),
                textAlign: TextAlign.start,
              ),
            ),
            if (nextPills != null && nextPills.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 24,
                ),
                itemBuilder: (context, index) {
                  if (index == nextPills.length) {
                    return StandardButtonLight(
                        onTap: () async {
                          pageNum++;
                          final result =
                              await ref.read(therapiesProvider).fetchMorePills(
                            {
                              'user_id': ref.read(authProvider).user?.userId,
                              'page_number': pageNum,
                            },
                          );
                          if (result.isEmpty) {
                            showredToast('Non hai ulteriori pillole', context);
                          }
                        },
                        text: 'Carica altre');
                  } else {
                    return PillTile(pill: nextPills[index]);
                  }
                },
                itemCount: nextPills.length + 1,
              )
            else if (user != null && nextPills != null && nextPills.isEmpty)
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: const NoData(),
              )
            else if (user == null)
              const NoUser()
            else
              Container(
                margin: const EdgeInsets.only(top: 10),
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
    );
  }
}
