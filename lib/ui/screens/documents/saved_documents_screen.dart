import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_first_tab.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_second_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class SavedDocumentsScreen extends ConsumerWidget {
  const SavedDocumentsScreen({Key? key}) : super(key: key);
  static const routeName = '/saved-documents-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: AppColors.darkGrey,
            labelColor: ref.read(flavorProvider).primary,
            indicatorColor: ref.read(flavorProvider).primary,
            tabs: [
              Tab(
                text: translate(context, 'all_documents'),
              ),
              Tab(
                text: translate(context, 'shared'),
              ),
            ],
          ),
          title: Text(
            translate(context, 'shared'),
            style: TextStyle(color: ref.read(flavorProvider).primary),
          ),
        ),
        body: user == null
            ? const NoUser()
            : const TabBarView(
                children: [
                  SavedDocumentsFirstTab(),
                  SavedDocumentsSecondTab(),
                ],
              ),
      ),
    );
  }
}
