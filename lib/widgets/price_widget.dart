import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/darkThemeProvider.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);

  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double userPrice = isOnSale ? salePrice : price;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
              text:
                  '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
              color: Colors.green,
              textSize: 18.sp),
          SizedBox(
            width: 5.w,
          ),
          Visibility(
              visible: isOnSale ? true : false,
              child: Text(
                '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: color,
                    decoration: TextDecoration.lineThrough),
              ))
        ],
      ),
    );
  }
}
