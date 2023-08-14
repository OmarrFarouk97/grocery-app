import 'package:adminpanal/widgets/on_sale_widget.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/darkThemeProvider.dart';
import '../models/products_model.dart';
import '../providers/products_providers.dart';
import '../widgets/empty_products.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";

  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    final ProductsProviders =Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale= ProductsProviders.getOnSaleProducts;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Products on sale',
            color: color,
            textSize: 24.sp,
            isTitle: true,
          ),
        ),
        body: productsOnSale.isEmpty
            ?  EmptyProWidget(
          text: 'No products belong to this ',
        )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1.h,
                  children: List.generate(productsOnSale.length, (index) {
                    return ChangeNotifierProvider.value(
                        value: productsOnSale[index],
                        child: const OnSaleWidget());
                  }),
                ),
              ));
  }
}
