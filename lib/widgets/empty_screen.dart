import 'package:adminpanal/inner_screen/feeds_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/darkThemeProvider.dart';
import '../business_logic/servies/globle_method.dart';
import 'back_widget.dart';
import 'text_widgets.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key,

    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.buttonText,
  }) : super(key: key);


  final String imagePath,title,subTitle,buttonText;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   leading: const BackWidget(),
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   title: TextWidget(
      //     text: 'History',
      //     color: color,
      //     textSize: 22.sp,
      //     isTitle: true,
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           GlobalMethod.warningDialog(
      //               title: 'Empty your cart ?',
      //               subTitle: 'are you sure ?',
      //               fct: () {},
      //               context: context);
      //         },
      //         icon: Icon(
      //           IconlyBroken.delete,
      //           color: color,
      //         ))
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h,),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 250.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Whoops!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextWidget(
                  text: title,
                  color: Colors.cyan,
                  textSize: 20.sp),
              SizedBox(
                height: 10.h,
              ),
              TextWidget(
                  text: subTitle,
                  color: Colors.cyan,
                  textSize: 20.sp),
              SizedBox(
                height: 100.h,
              ),
              ElevatedButton(

                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    primary: Theme.of(context).colorScheme.secondary,
                    onPrimary: color,
                    textStyle: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20)),
                onPressed: () {
                  GlobalMethod.navigateTo(
                      ctx: context, routeName: FeedsScreen.routeName);
                },
                child: TextWidget(
                  text: buttonText,
                  color: themeState.getDarkTheme
                      ? Colors.grey.shade300
                      : Colors.grey.shade800,
                  textSize: 20.sp,
                  isTitle: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
