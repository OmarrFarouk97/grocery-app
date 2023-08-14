import 'package:adminpanal/providers/Viewed_prodProvider.dart';
import 'package:adminpanal/screens/viewed_recently/viewed_widget.dart';
import 'package:adminpanal/screens/wishlist/wishlist_widget.dart';
import 'package:adminpanal/widgets/empty_screen.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../business_logic/servies/globle_method.dart';
import '../../widgets/back_widget.dart';
import '../cart/cart_widget.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = "/ViewedRecentlyScreen";

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyScreen> createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    final viewedProdItemsList = viewedProdProvider.getViewedProdListItems.values
        .toList()
        .reversed
        .toList();

    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'your history is empty',
        subTitle: ' No product has been viewed yet!',
        buttonText: 'Shop now',
        imagePath: "assets/images/history.png",

      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'History',
            color: color,
            textSize: 22.sp,
            isTitle: true,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  GlobalMethod.warningDialog(
                      title: 'Empty your history',
                      subTitle: 'are you sure?',
                      fct: () {},
                      context: context);
                },
                icon: Icon(
                  IconlyBroken.delete,
                  color: color,
                ))
          ],
        ),
        body: ListView.builder(
            itemCount: viewedProdItemsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: viewedProdItemsList[index],
                    child:  ViewedRecentlyWidget()),
              );
            }),
      );
    }
  }
}
