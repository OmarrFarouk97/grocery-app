import 'package:adminpanal/screens/categories/categories_widgets.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';

class CategoriesScreen extends StatelessWidget {

   CategoriesScreen({Key? key}) : super(key: key);
   List<Map<String, dynamic>> catInfo = [
     {
       'imgPath': 'assets/images/cat/fruits.png',
       'catText': 'Fruits',
     },
     {
       'imgPath': 'assets/images/cat/veg.png',
       'catText': 'Vegetables',
     },
     {
       'imgPath': 'assets/images/cat/Spinach.png',
       'catText': 'Herbs',
     },
     {
       'imgPath': 'assets/images/cat/nuts.png',
       'catText': 'Nuts',
     },
     {
       'imgPath': 'assets/images/cat/spices.png',
       'catText': 'Spices',
     },
     {
       'imgPath': 'assets/images/cat/grains.png',
       'catText': 'Grains',
     },
   ];
   List<Color> gridColors=[
     const Color(0xff53b175),
     const Color(0xfff8a44c),
     const Color(0xfff7a593),
     const Color(0xffd3b0e0),
     const Color(0xfffde598),
     const Color(0xffb7dff5),
   ];

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color= themeState.getDarkTheme ? Colors.white:Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextWidget(text: 'Categories', color: color, textSize: 20.sp,isTitle: true,),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
        body: Padding(
          padding:  EdgeInsets.all(8.0.w),
          child: GridView.count(
              crossAxisCount: 2,
            childAspectRatio: 240/250.w,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.w,
            children: List.generate(6, (index) {
              return CategoriesWidget(catText: catInfo[index]['catText'], imgPath: catInfo[index]['imgPath'], passedColor: gridColors[index]);
            }),

          ),
        ),
    );
  }
}
