import 'package:contacta_pharmacy/providers/auth_provider.dart';
import 'package:contacta_pharmacy/providers/therapies_provider.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/dialogs/custom_dialog.dart';
import 'package:contacta_pharmacy/ui/screens/therapies/edit_therapy_first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/flavor.dart';
import '../../../models/pill.dart';
import '../../../models/therapy.dart';
import '../../../theme/app_colors.dart';
import '../../../translations/translate_string.dart';

class CustomEditTherapyDialog extends ConsumerWidget {
  const CustomEditTherapyDialog({
    Key? key,
    required this.therapy,
  }) : super(key: key);
  final Therapy therapy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: ref.read(flavorProvider).primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: ref.read(flavorProvider).primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  therapy.startDate,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //TODO fix
          /*   Container(
            color: Colors.white,
            height: 80,
            child: Row(
              children: [],
            ),
          ),*/
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: translate(context, 'delete_therapy'),
                          children: [
                            Text(
                              translate(context, 'delete_therapy_des'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(therapiesProvider)
                                          .deleteTherapy({
                                        'user_id':
                                            ref.read(authProvider).user?.userId,
                                        'therapy_id': therapy.id,
                                        'pharmacy_id':
                                            ref.read(flavorProvider).pharmacyId,
                                      });
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.darkRed,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translate(
                                            context,
                                            'delete_single',
                                          ),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ref
                                            .read(flavorProvider)
                                            .lightPrimary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Center(
                                        child: Text(
                                          'Annulla',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Cancella',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).pushNamed(
                  //       EditTherapyFirstScreen.routeName,
                  //       arguments: therapy,
                  //     );
                  //   },
                  //   child: Column(
                  //     children: [
                  //       const Icon(Icons.edit),
                  //       Text(translate(context, "edit")),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomEditPillDialog extends ConsumerStatefulWidget {
  const CustomEditPillDialog({
    Key? key,
    required this.pill,
  }) : super(key: key);

  final Pill pill;

  @override
  _CustomEditPillDialogState createState() => _CustomEditPillDialogState();
}

class _CustomEditPillDialogState extends ConsumerState<CustomEditPillDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ref.read(flavorProvider).primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: ref.read(flavorProvider).primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.pill.date ?? '',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: translate(context, 'delete_therapy'),
                          children: [
                            Text(translate(context, 'delete_therapy_des')),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.darkRed,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          translate(
                                            context,
                                            'delete_single',
                                          ),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ref
                                            .read(flavorProvider)
                                            .lightPrimary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Center(
                                        child: Text(
                                          'Annulla',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Cancella',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
