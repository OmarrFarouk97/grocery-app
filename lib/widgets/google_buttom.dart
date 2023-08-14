import 'package:adminpanal/consts/firebase_const.dart';
import 'package:adminpanal/fetch_screen.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../business_logic/servies/globle_method.dart';
import '../screens/btm_bar.dart';

class GoogleButton extends StatelessWidget {
   GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if (googleAccount != null) {
      final googleAuth=await googleAccount.authentication;
     if (googleAuth.accessToken!=null && googleAuth.idToken !=null){
       try {
         final authResult= await authInstance.signInWithCredential(
           GoogleAuthProvider.credential(idToken: googleAuth.idToken,
           accessToken: googleAuth.accessToken));
         if (authResult.additionalUserInfo!.isNewUser){
           await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set(
               {
                 'id':authResult.user!.uid,
                 'name':authResult.user!.displayName,
                 'email':authResult.user!.email,
                 'shipping-address':'',
                 'userWish':[],
                 'userCart':[],
                 'createAt':Timestamp.now(),

               });
         }


         Navigator.of(context).push(MaterialPageRoute(
             builder: (context) => const FetchScreen()));
       } on FirebaseException catch (error) {
         GlobalMethod.errorDialog(subTitle: "${error.message}", context: context);

       } catch (error) {
         GlobalMethod.errorDialog(subTitle: "$error", context: context);

       } finally {}
     }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'assets/images/google.png',
                width: 33.w,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            TextWidget(
                text: 'Sign in with google',
                color: Colors.white,
                textSize: 16.sp)
          ],
        ),
      ),
    );
  }
}
