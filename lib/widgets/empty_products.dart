import 'package:adminpanal/business_logic/servies/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyProWidget extends StatelessWidget {
  const EmptyProWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset('assets/images/box.png'),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 28.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
