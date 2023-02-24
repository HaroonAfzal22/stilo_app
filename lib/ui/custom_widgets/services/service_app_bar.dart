import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../translations/translate_string.dart';

class ServiceAppbar extends ConsumerWidget with PreferredSizeWidget {
  const ServiceAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        translate(context, 'services'),
        style: TextStyle(color: ref.read(flavorProvider).primary),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
