import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/ui/screens/sent_to_pharmacy/sent_product_from_photo_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../custom_widgets/no_data.dart';

class SentProductFromPhotoTab extends ConsumerStatefulWidget {
  const SentProductFromPhotoTab({Key? key}) : super(key: key);

  @override
  ConsumerState<SentProductFromPhotoTab> createState() =>
      _SentProductFromPhotoTabState();
}

class _SentProductFromPhotoTabState
    extends ConsumerState<SentProductFromPhotoTab> {
  List<dynamic>? products;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAllProducts() async {
    final result = await _apisNew.getAllProductFromPhoto({
      'user_id': ref.read(authProvider).user?.userId,
    });
    products = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (ref.read(authProvider).user != null) {
      getAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          if (products != null && products!.isNotEmpty)
            ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductFromPhotoDetailScreen.routeName,
                              arguments: products![index]);
                        },
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        title: Text('ID: ' + products![index]['id'].toString()),
                        leading: Image.asset('assets/images/noImage.png'),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: products!.length)
          else if (products != null && products!.isEmpty)
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              child: const NoData(),
            )
          else
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
    );
  }
}
