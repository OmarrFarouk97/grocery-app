import 'dart:convert';
import 'dart:developer';

import 'package:adminpanal/providers/darkThemeProvider.dart';
import 'package:adminpanal/inner_screen/feeds_screen.dart';
import 'package:adminpanal/inner_screen/on_sale_screen.dart';
import 'package:adminpanal/providers/Viewed_prodProvider.dart';
import 'package:adminpanal/providers/cart_provider.dart';
import 'package:adminpanal/providers/order_provider.dart';
import 'package:adminpanal/providers/products_providers.dart';
import 'package:adminpanal/providers/wishlist_provider.dart';
import 'package:adminpanal/screens/auth/forget_pass.dart';
import 'package:adminpanal/screens/auth/login.dart';
import 'package:adminpanal/screens/auth/register.dart';
import 'package:adminpanal/screens/btm_bar.dart';
import 'package:adminpanal/screens/categories/categories.dart';
import 'package:adminpanal/screens/homescreen/home_screen.dart';
import 'package:adminpanal/screens/orders/orders_screen.dart';
import 'package:adminpanal/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:adminpanal/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'inner_screen/cat_screen.dart';
import 'inner_screen/product_details_screen.dart';
import 'package:http/http.dart' as http;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
  "pk_test_51ND59fKXVdoZTRe9lbpVAAeFmjUG4l04T8Rh3P7lFagKLXkAf6ZiMI1jvZwZMNZCcxXs96SWiViQ5zVP4eRJo0DN00eG9gvqiN";
  Stripe.instance.applySettings();


  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return FutureBuilder(
            future: firebaseInitialization,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(
                      child: Text('An error occurred'),
                    ),
                  ),
                );
              }
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) {
                    return themeChangeProvider;
                  }),
                  ChangeNotifierProvider(create: (_) {
                    return ProductsProvider();
                  }),
                  ChangeNotifierProvider(create: (_) {
                    return CartProvider();
                  }),
                  ChangeNotifierProvider(create: (_) {
                    return WishlistProvider();
                  }),
                  ChangeNotifierProvider(create: (_) {
                    return ViewedProdProvider();
                  }),
                  ChangeNotifierProvider(create: (_) {
                    return OrdersProvider();
                  }),
                ],
                child: Consumer<DarkThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme:
                          Styles.themeData(themeProvider.getDarkTheme, context),
                      home:
                          //LoginScreen(),
                          //ProductsDetails(),
                          //BottomBarScreen(),
                          // HomeScreen(),
                          //LoginScreen(),
                          FetchScreen(),
                      //    PaymentDemo(),
                      routes: {
                        OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                        FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                        ProductsDetails.routeName: (ctx) =>
                            const ProductsDetails(),
                        WishlistScreen.routeName: (ctx) =>
                            const WishlistScreen(),
                        OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                        ViewedRecentlyScreen.routeName: (ctx) =>
                            const ViewedRecentlyScreen(),
                        LoginScreen.routeName: (ctx) => const LoginScreen(),
                        RegisterScreen.routeName: (ctx) =>
                            const RegisterScreen(),
                        ForgetPasswordScreen.routeName: (ctx) =>
                            const ForgetPasswordScreen(),
                        CategoryScreen.routeName: (ctx) =>
                            const CategoryScreen(),
                      },
                    );
                  },
                ),
              );
            },
          );
        });
  }
}

class PaymentDemo extends StatelessWidget {
  const PaymentDemo({Key? key}) : super(key: key);

  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {

    try {
      // 1. Create a payment intent on the server
      var response = await http.post(Uri.parse(
              'https://us-central1-grocery-43346.cloudfunctions.net/stripePaymentIntentRequest') ,
          body: {
            'email': email,
            'amount': amount.toString(),
          },

      );

      var jsonResponse = await jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'grocery-43346',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],

      ));
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
    } catch (errorr) {
      if (errorr is StripeException) {
        print(errorr);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured ${errorr.error.localizedMessage}'),
          ),
        );
      } else {
        print(errorr);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occured $errorr'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Pay 50\$'),
          onPressed: () async {
            await initPayment(
                amount: 50.0, context: context, email: 'email@test.com');
          },
        ),
      ),
    );
  }
}
