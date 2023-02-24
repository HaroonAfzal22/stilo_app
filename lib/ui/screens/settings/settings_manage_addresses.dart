import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/models/address.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_add_address.dart';
import 'package:contacta_pharmacy/ui/screens/settings/settings_edit_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class SettingsManageAddresses extends ConsumerStatefulWidget {
  const SettingsManageAddresses({Key? key}) : super(key: key);
  static const routeName = '/settings-manage-addresses';

  @override
  _SettingsManageAddressesState createState() =>
      _SettingsManageAddressesState();
}

class _SettingsManageAddressesState
    extends ConsumerState<SettingsManageAddresses> {
  List<Address>? addressesList;
  final ApisNew _apisNew = ApisNew();

  Future<void> getAddresses() async {
    final result = await _apisNew.getAddressesList({
      'user_id': 1394,
    });
    addressesList = [];
    for (var addressItem in result.data) {
      addressesList!.add(Address.fromJson(addressItem));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await getAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ref.read(flavorProvider).lightPrimary,
        child: const Icon(
          Icons.add,
          size: 32,
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(SettingsAddAddress.routeName)
              .then((value) async {
            setState(() {
              addressesList = null;
            });
            await getAddresses();
          });
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          translate(
            context,
            'edit_manage_address',
          ),
        ),
      ),
      body: addressesList == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: addressesList!.length,
                      itemBuilder: (context, index) => AddressItem(
                        address: addressesList![index],
                        update: () async {
                          setState(() {
                            addressesList = null;
                          });
                          await getAddresses();
                        },
                      ),
                    )
                    //TODO fix
                    /*  Text(
                translate(context, 'home'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) => const AddressItem(),
              ),
              Text(
          x      translate(context, 'other'),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) => const AddressItem(),
              ),*/
                  ],
                ),
              ),
            ),
    );
  }
}

class AddressItem extends ConsumerWidget {
  const AddressItem({Key? key, required this.address, required this.update})
      : super(key: key);
  final Address? address;

  final Function() update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(address!.name!,
          style: AppTheme.h6Style
              .copyWith(color: AppColors.black, fontWeight: FontWeight.w600)),
      subtitle: Text(address!.address!,
          style: AppTheme.bodyText.copyWith(color: AppColors.lightGrey)),
      trailing: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(SettingsEditAddress.routeName, arguments: address)
              .then((value) => update());
        },
        child: Icon(
          Icons.edit,
          color: ref.read(flavorProvider).lightPrimary,
        ),
      ),
    );
  }
}
