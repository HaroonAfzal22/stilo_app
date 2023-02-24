import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/screens/shift_zoom_image_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../models/flavor.dart';
import '../../theme/app_colors.dart';
import '../../translations/translate_string.dart';

class ShiftsScreen extends ConsumerStatefulWidget {
  const ShiftsScreen({Key? key}) : super(key: key);
  static const routeName = '/shifts-screen';

  @override
  ConsumerState<ShiftsScreen> createState() => _ShiftsScreenState();
}

class _ShiftsScreenState extends ConsumerState<ShiftsScreen> {
  final ApisNew _apisNew = ApisNew();
  dynamic shifts;

  Future<void> getShifts() async {
    final result = await _apisNew.getShifts(
      {
        'pharmacy_id': ref.read(flavorProvider).pharmacyId,
      },
    );

    shifts = result.data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          translate(context, 'Our_Shifts'),
        ),
      ),
      body: shifts != null
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate(context, "shift_lift"),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      translate(context, "shifts_desc"),
                      style: TextStyle(
                        color: AppColors.lightGrey.withOpacity(0.7),
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ShiftZoomImageDetail.routeName,
                              arguments: shifts['image']);
                        },
                        child: CachedNetworkImage(imageUrl: shifts['image'])),
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: ref.read(flavorProvider).lightPrimary,
                ),
              ),
            ),
    );
  }
}
