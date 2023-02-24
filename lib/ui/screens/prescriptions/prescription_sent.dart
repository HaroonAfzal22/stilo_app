import 'package:contacta_pharmacy/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme.dart';
import '../../../translations/translate_string.dart';

class ItemSent extends StatelessWidget {
  const ItemSent({Key? key}) : super(key: key);
  static const routeName = '/prescription-sent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Image.asset(
                  'assets/images/ic_successorder.png',
                  height: 35.0.h,
                ),
              ),
            ),
            Center(
              child: Text('Inviato alla farmacia con successo!',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleStyle
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.bodyText.copyWith(
                      fontSize: 10.0.sp, fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                        text: '',
                        style: AppTheme.bodyText.copyWith(
                            fontSize: 10.0.sp, fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: '',
                        style: AppTheme.bodyText.copyWith(
                            fontSize: 10.0.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(MainScreen.routeName);
                },
                child: Text(
                  translate(context, "go_to_home"),
                  style: AppTheme.h6Style.copyWith(color: AppColors.lightGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
