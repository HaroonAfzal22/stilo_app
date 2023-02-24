import 'dart:io';

import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/config/MyApplication.dart' as myapp;
import 'package:contacta_pharmacy/models/contacts.dart';
import 'package:contacta_pharmacy/providers/time_tables_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/flavor.dart';
import '../../providers/site_provider.dart';
import '../../theme/theme.dart';
import '../../translations/translate_string.dart';

class PharmacySocialItems extends ConsumerStatefulWidget {
  const PharmacySocialItems({Key? key}) : super(key: key);

  @override
  ConsumerState<PharmacySocialItems> createState() =>
      _PharmacySocialItemsState();
}

class _PharmacySocialItemsState extends ConsumerState<PharmacySocialItems> {
  final ApisNew _apisNew = ApisNew();

  String formattedPhone = "";
  String formattedPhoneWhatsapp = "";

  Future<void> getContacts() async {
    final result = await _apisNew.getContact(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
        "sede_id": ref.read(siteProvider)!.id,
      },
    );

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getContacts();
    });
  }

  List<Widget> getItems(Contact? contact) {
    if (contact != null && contact.phone != null) {
      formattedPhone = contact.phone!.replaceAll(" ", "");
    }
    if (contact != null && contact.whatsapp != null) {
      formattedPhoneWhatsapp = contact.whatsapp!.replaceAll(" ", "");
    }

    final List<Widget> widgets = [];

    if (contact?.facebookLink?.isNotEmpty ?? false) {
      widgets.add(
        GestureDetector(
          onTap: () {
            myapp.launchUrl("${contact!.facebookLink}");
          },
          child: const SocialItem(
            title: 'Facebook',
            imgUrl: 'assets/icons/pharmacy_fb.png',
          ),
        ),
      );
    }

    if (contact?.instagramLink?.isNotEmpty ?? false) {
      widgets.add(
        GestureDetector(
          onTap: () {
            myapp.launchUrl("${contact!.instagramLink}");
          },
          child: const SocialItem(
            title: 'Instagram',
            imgUrl: 'assets/icons/instagram.png',
          ),
        ),
      );
    }

    if (contact?.whatsapp?.isNotEmpty ?? false) {
      widgets.add(
        GestureDetector(
          // onTap: () => launchUrl(
          //     "https://wa.me/${contact!.phone}"),
          onTap: () => openwhatsapp(),
          child: const SocialItem(
            title: 'Whatsapp',
            imgUrl: 'assets/icons/whatsapp.png',
          ),
        ),
      );
    }

    if (contact?.phone?.isNotEmpty ?? false) {
      widgets.add(
        GestureDetector(
          onTap: () {
            launch("tel://$formattedPhone");
          },
          child: SocialItem(
            title: translate(context, 'call_us'),
            imgUrl: 'assets/icons/pharmacy_call.png',
            // onTap: () {
            //},
          ),
        ),
      );
    }

    if (contact?.facebookLink?.isEmpty ?? true) {
      widgets.add(const SizedBox.shrink());
    }

    if (contact?.instagramLink?.isEmpty ?? true) {
      widgets.add(const SizedBox.shrink());
    }

    if (contact?.whatsapp?.isEmpty ?? true) {
      widgets.add(const SizedBox.shrink());
    }

    if (contact?.phone?.isEmpty ?? true) {
      widgets.add(const SizedBox.shrink());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final contact = ref.watch(contactsProvider);

    final items = getItems(contact.value);

    return contact.value != null
        ? Row(
            children: [
              Expanded(child: items[0]),
              const SizedBox(width: 16),
              Expanded(child: items[1]),
              const SizedBox(width: 16),
              Expanded(child: items[2]),
              const SizedBox(width: 16),
              Expanded(child: items[3]),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: ref.read(flavorProvider).lightPrimary,
            ),
          );
  }

  openwhatsapp() async {
    var whatsappURl_android =
        "whatsapp://send?phone=$formattedPhoneWhatsapp&text=Salve";
    var whatappURL_ios =
        "https://wa.me/$formattedPhoneWhatsapp?text=${Uri.parse("Salve")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }
}

class SocialItem extends StatelessWidget {
  const SocialItem({
    Key? key,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);
  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imgUrl),
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.bodyText.copyWith(fontSize: 10.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
