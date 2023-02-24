import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductPhotoDetail extends StatefulWidget {
  const ProductPhotoDetail({Key? key}) : super(key: key);
  static const routeName = '/product-photo-detail';

  @override
  State<ProductPhotoDetail> createState() => _ProductPhotoDetailState();
}

class _ProductPhotoDetailState extends State<ProductPhotoDetail> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        imageUrl = ModalRoute.of(context)?.settings.arguments as String;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: imageUrl != null
          ? PhotoView(
              imageProvider: NetworkImage(imageUrl ??
                  'https://www.iconsdb.com/icons/preview/white/square-xxl.png'),
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const SizedBox();
              },
            )
          : const SizedBox(),
    );
  }
}
