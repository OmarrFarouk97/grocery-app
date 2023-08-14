import 'package:adminpanal/inner_screen/cat_screen.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key, required this.catText, required this.imgPath, required this.passedColor}) : super(key: key);
  final String catText,imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color= themeState.getDarkTheme ? Colors.white:Colors.black;

    return  InkWell(
      onTap: (){
        Navigator.pushNamed(context, CategoryScreen.routeName,
        arguments:catText );
        
      },
      child: Container(
        // height: 160.h,
        // width:150.w ,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: passedColor.withOpacity(0.7),width: 4.w),
        ),
        child: Column(
          children: [
            SizedBox(height: 14.h,),
            Container(
              height:90.h ,
              width:90.w ,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath,),fit: BoxFit.fill
                )
              ),
            ),
            SizedBox(height: 10.h,),
            TextWidget(text: catText, color: color, textSize: 20.sp,isTitle: true,)
          ],
        ),
      ),
    );
  }
}
