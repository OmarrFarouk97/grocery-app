
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../consts/firebase_const.dart';
import '../../widgets/text_widgets.dart';
import 'package:uuid/uuid.dart';

class GlobalMethod{

 static navigateTo({required BuildContext ctx, required String routeName }){
    Navigator.pushNamed(ctx  ,routeName);
  }
  static   Future<void>warningDialog({
   required String title,
   required String subTitle,
   required Function fct,
    required BuildContext context,

}) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Row(
              children: [
                Image.asset(
                  'assets/images/warning-sign.png',
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 5.w,),
                  Text(title)
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(onPressed: () {
                if (Navigator.canPop(context)){
                  Navigator.pop(context);
                }

              }, child: TextWidget(
                color: Colors.cyan,
                text: 'Cancel',
                textSize: 18.sp,
              ),),
              TextButton(onPressed: () {
                fct();
                if (Navigator.canPop(context)){
                  Navigator.pop(context);

                }
              }, child: TextWidget(
                color: Colors.red,
                text: 'Ok',
                textSize: 18.sp,
              ),),

            ],
          );
        });
  }

 static   Future<void>errorDialog({

   required String subTitle,

   required BuildContext context,

 }) async {
   showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(

           title: Row(
             children: [
               Image.asset(
                 'assets/images/warning-sign.png',
                 width: 20.w,
                 height: 20.h,
                 fit: BoxFit.fill,
               ),
               SizedBox(width: 5.w,),
               Text('An error occurred')
             ],
           ),
           content: Text(subTitle),
           actions: [
             TextButton(onPressed: () {
               if (Navigator.canPop(context)){
                 Navigator.pop(context);
               }

             }, child: TextWidget(
               color: Colors.cyan,
               text: 'Ok',
               textSize: 18.sp,
             ),),


           ],
         );
       });
 }


 static Future<void> addToCart(
     {required String productId,
       required int quantity,
       required BuildContext context}) async {
   final User? user = authInstance.currentUser;
   final _uid = user!.uid;
   final cartId =  Uuid().v4();
   try {
     FirebaseFirestore.instance.collection('users').doc(_uid).update({
       // 3sham adef array be esm l filed eli esmo userCart eli mwgod fe firebase  be  8aga esmha (fieldValue.arrayUmiom)
       // we b3den apass lista  mn array feha cart id fa lazm a3ml mot8er y3mle  generate ll id emsha uuid
       'userCart': FieldValue.arrayUnion([
         {
           'cartId': cartId,
           'productId': productId,
           'quantity': quantity,
         }
       ])
     });
     await Fluttertoast.showToast(
       msg: "Item has been added to your cart",
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
     );
   } catch (error) {
     errorDialog(subTitle: error.toString(), context: context);
   }
 }


 static Future<void> addToWishlist(
     {required String productId, required BuildContext context}) async {
   final User? user = authInstance.currentUser;
   final _uid = user!.uid;
   final wishlistId = const Uuid().v4();
   try {
     FirebaseFirestore.instance.collection('users').doc(_uid).update({
       'userWish': FieldValue.arrayUnion([
         {
           'wishlistId': wishlistId,
           'productId': productId,
         }
       ])
     });
     await Fluttertoast.showToast(
       msg: "Item has been added to your wishlist",
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
     );
   } catch (error) {
     errorDialog(subTitle: error.toString(), context: context);
   }
 }


}