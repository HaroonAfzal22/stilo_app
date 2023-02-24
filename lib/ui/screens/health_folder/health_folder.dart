import 'package:contacta_pharmacy/ui/screens/health_folder/health_folder_values_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';
import 'health_folder_health_profile_tab.dart';

class HealthFolder extends ConsumerStatefulWidget {
  const HealthFolder({Key? key}) : super(key: key);
  static const routeName = '/health-folder';

  @override
  ConsumerState<HealthFolder> createState() => _HealthFolderState();
}

class _HealthFolderState extends ConsumerState<HealthFolder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'health_folder'),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: ref.read(flavorProvider).lightPrimary,
            tabs: [
              Tab(
                  icon: const Icon(Icons.bar_chart),
                  text: translate(context, 'My_Values')),
              Tab(
                  icon: const Icon(Icons.folder),
                  text: translate(context, 'Health_Profile'))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HealthFolderValuesTab(),
            HealthFolderHealthProfileTab(),
          ],
        ),
      ),
    );
  }
}
