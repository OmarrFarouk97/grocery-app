import 'package:adminpanal/business_logic/servies/globle_method.dart';
import 'package:adminpanal/consts/firebase_const.dart';
import 'package:adminpanal/screens/auth/forget_pass.dart';
import 'package:adminpanal/screens/auth/login.dart';
import 'package:adminpanal/screens/loading_manger.dart';
import 'package:adminpanal/screens/orders/orders_screen.dart';
import 'package:adminpanal/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/darkThemeProvider.dart';
import '../../widgets/text_widgets.dart';
import '../wishlist/wishlist_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }


  String? _email;
  String? _name;
  String? address;


  bool _isLoading = false;
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uId = user!.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users').doc(_uId).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethod.errorDialog(
          subTitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: 'Hi,   ',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: _name ?? 'user',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('print is pressed');
                                    }),
                            ])),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextWidget(
                      text: _email == null ? "Email" : _email!,
                      color: color,
                      textSize: 18.sp,
                      isTitle: true,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      thickness: 2.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    listTileRow(
                        title: 'Address',
                        icon: IconlyBold.profile,
                        onPressed: () async {
                          await _showAddressDialog();
                        },
                        subTile: address,
                        color: color),
                    listTileRow(
                        title: 'Order',
                        icon: IconlyBold.bag,
                        onPressed: () {
                          GlobalMethod.navigateTo(
                              ctx: context, routeName: OrdersScreen.routeName);
                        },
                        color: color),
                    listTileRow(
                        title: 'Wishlist',
                        icon: IconlyBold.heart,
                        onPressed: () {
                          GlobalMethod.navigateTo(
                              ctx: context,
                              routeName: WishlistScreen.routeName);
                        },
                        color: color),
                    listTileRow(
                        title: 'Viewed ',
                        icon: IconlyBold.show,
                        onPressed: () {
                          GlobalMethod.navigateTo(
                              ctx: context,
                              routeName: ViewedRecentlyScreen.routeName);
                        },
                        color: color),
                    listTileRow(
                        title: 'Forget password',
                        icon: IconlyBold.unlock,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (
                                  context) => const ForgetPasswordScreen()));
                        },
                        color: color),
                    SwitchListTile(
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      title: Text(
                        themeState.getDarkTheme ? 'Dark Mode' : 'Light mode',
                        style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme,
                    ),
                    listTileRow(
                        title: user == null ? 'Login' : 'Logout',
                        icon: user == null ? IconlyBold.login : IconlyBold
                            .logout,
                        onPressed: () {
                          if (user == null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                            return;
                          }

                          GlobalMethod.warningDialog(
                              title: 'Sign out',
                              subTitle: 'Do you wanna sign out ?',
                              fct: () async {
                                await authInstance.signOut();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                              },
                              context: context);
                        },
                        color: color),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: TextField(
              onChanged: (value) {
                // print('${_addressTextController.text}');
                //_addressTextController.text;
              },
              controller: _addressTextController!,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Your address'),
            ),
            actions: [
              TextButton(onPressed: () async {
                try {
                  String _uId = user!.uid;
                  await FirebaseFirestore.instance.collection('users')
                      .doc(_uId)
                      .update(
                      {'shipping-address': _addressTextController.text}
                  );
                  Navigator.pop(context);

                  setState(() {
                    address=_addressTextController.text;

                  });
                } catch (error) {
                  GlobalMethod.errorDialog(
                      subTitle: error.toString(), context: context);
                }
              }, child: const Text('Update'))
            ],
          );
        });
  }

  Widget listTileRow({
    required String title,
    String? subTile,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18.sp,
        isTitle: true,
      ),
      subtitle: TextWidget(
        text: subTile ?? '',
        color: color,
        textSize: 12.sp,
        isTitle: false,
      ),
      leading: Icon(IconlyLight.profile),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
