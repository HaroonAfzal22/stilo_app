import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/document.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/documents/saved_documents_first_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../../models/flavor.dart';

class SavedDocumentsSecondTab extends ConsumerStatefulWidget {
  const SavedDocumentsSecondTab({Key? key}) : super(key: key);

  @override
  _SavedDocumentsSecondTabState createState() =>
      _SavedDocumentsSecondTabState();
}

class _SavedDocumentsSecondTabState
    extends ConsumerState<SavedDocumentsSecondTab> {
  final ApisNew _apisNew = ApisNew();
  List<PharmaDocument>? documentsList;

  Future<void> getDocuments() async {
    final result = await _apisNew.getDocuments({
      'user_id': ref.read(authProvider).user?.userId,
      'pharmacy_id': 1,
      'type': 'share'
    });
    documentsList = [];
    for (var documentItem in result.data) {
      documentsList!.add(PharmaDocument.fromJson(documentItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      getDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (documentsList != null)
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.1.h,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  // itemCount: documentsList.length,
                  itemCount: documentsList!.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? const AddDocumentBox()
                        : DocumentBox(
                            document: documentsList![index - 1],
                          );
                  })
            else
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ref.read(flavorProvider).lightPrimary,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
