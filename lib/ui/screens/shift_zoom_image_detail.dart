import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShiftZoomImageDetail extends StatelessWidget {
  const ShiftZoomImageDetail({Key? key}) : super(key: key);
  static const routeName = '/shift_zoom_detail';

  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)?.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl!),
      ),
    );
  }
}
