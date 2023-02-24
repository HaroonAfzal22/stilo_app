import 'package:contacta_pharmacy/translations/translate_string.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/search_bar.dart';
import 'package:flutter/material.dart';

//TODO da rimuovere e pushandreplace con ricerca???

class ProductsShowAll extends StatefulWidget {
  const ProductsShowAll({Key? key}) : super(key: key);
  static const routeName = '/products-show-all';

  @override
  _ProductsShowAllState createState() => _ProductsShowAllState();
}

class _ProductsShowAllState extends State<ProductsShowAll> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          translate(context, 'products'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(controller: _controller),
            const SizedBox(
              height: 16,
            ),
            //TODO add gridview
          ],
        ),
      ),
    );
  }
}
