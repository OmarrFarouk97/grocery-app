import 'package:adminpanal/business_logic/servies/globle_method.dart';
import 'package:adminpanal/fetch_screen.dart';
import 'package:adminpanal/screens/auth/register.dart';
import 'package:adminpanal/screens/btm_bar.dart';
import 'package:adminpanal/screens/loading_manger.dart';
import 'package:adminpanal/widgets/auth_button.dart';
import 'package:adminpanal/widgets/google_buttom.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../consts/constt.dart';
import '../../consts/firebase_const.dart';
import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  // void _submitFormOnLogin() {
  //   final isValid = _formKey.currentState!.validate();
  //   FocusScope.of(context).unfocus();
  //   if (isValid) {
  //     print('the form is valid');
  //   }
  // }



  bool _isLoading = false;

  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();


    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FetchScreen()));

        print('Successfully Logged in');
      } on FirebaseException catch (error) {
        print(' An error occurred');
        GlobalMethod.errorDialog(
            subTitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
       // print(' An error occurred');
        GlobalMethod.errorDialog(subTitle: "$error", context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 60000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constss.authImagesPaths[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              itemCount: Constss.authImagesPaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 120.h,
                    ),
                    TextWidget(
                      text: 'Welcome Back',
                      color: Colors.white,
                      textSize: 30.sp,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextWidget(
                      text: 'Sign in to continue',
                      color: Colors.white,
                      textSize: 18.sp,
                      isTitle: false,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          // password
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a valid password';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          GlobalMethod.navigateTo(ctx: context, routeName: ForgetPasswordScreen.routeName);
                        },
                        child: Text(
                          'Forget password?',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 16.sp,
                              // decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    AuthButton(fct: _submitFormOnLogin,
                         buttonText: 'Login'),
                    SizedBox(
                      height: 10.h,
                    ),
                     GoogleButton(),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        TextWidget(text: 'OR', color: Colors.white, textSize: 18.sp),
                        SizedBox(width: 5.w,),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    AuthButton(fct: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FetchScreen()));
                    }, buttonText: 'Continue as a guest',primary: Colors.black,),
                    SizedBox(
                      height: 10.h,
                    ),
                    RichText(text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style:  TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap=(){
                            GlobalMethod.navigateTo(ctx: context, routeName: RegisterScreen.routeName);

                          }
                        )
                      ]
                    ),

                    ),



                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
