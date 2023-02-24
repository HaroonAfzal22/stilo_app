import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/time_tables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contacts.dart';
import '../models/flavor.dart';
import 'site_provider.dart';

final timeTableProvider = FutureProvider<TimeTables?>((ref) {
  final apisNews = ApisNew();
  final flavor = ref.read(flavorProvider);
  final site = ref.watch(siteProvider);

  return apisNews.getTimeTablesV3({
    "pharmacy_id": flavor.pharmacyId,
    "sede_id": site!.id,
  });
});

final contactsProvider = FutureProvider<Contact?>((ref) {
  final apisNew = ApisNew();
  final flavor = ref.read(flavorProvider);
  final site = ref.watch(siteProvider);

  return apisNew.getContact(
    {
      'pharmacy_id': flavor.pharmacyId,
      "sede_id": site!.id,
    },
  );
});

// final timeTablesProvider = ChangeNotifierProvider((ref) {
//   final Flavor flavor = ref.read(flavorProvider);
//   final site = ref.read(multiSedeProvider).selectedSede;
//   return TimeTableProvider(flavor, site);
// });

// class TimeTableProvider extends ChangeNotifier {
//   TimeTableProvider(this.flavor, this.site);

//   final Flavor flavor;
//   TimeTables? timeTable;
//   Sede? site;
//   final _apisNews = ApisNew();

//   Future<void> getTimeTables() async {
//     if (flavor.hasMultiSite) {
//       timeTable = await _apisNews.getTimeTablesV3(
//           {"pharmacy_id": flavor.pharmacyId, "sede_id": site!.id});
//     } else {
//       timeTable =
//           await _apisNews.getTimeTables({"pharmacy_id": flavor.pharmacyId});
//     }
//     notifyListeners();
//   }
// }
