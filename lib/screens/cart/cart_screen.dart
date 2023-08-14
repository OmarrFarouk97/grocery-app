import 'package:adminpanal/providers/cart_provider.dart';
import 'package:adminpanal/providers/order_provider.dart';
import 'package:adminpanal/providers/products_providers.dart';
import 'package:adminpanal/widgets/empty_screen.dart';
import 'package:adminpanal/widgets/text_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../consts/firebase_const.dart';
import '../../providers/darkThemeProvider.dart';
import '../../business_logic/servies/globle_method.dart';
import 'cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    final cartProvider = Provider.of<CartProvider>(context);

    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemsList.isEmpty
        ? EmptyScreen(
            title: 'your cart is empty',
            subTitle: 'Add something and make me happy ;)',
            imagePath: "assets/images/cart.png",
            buttonText: 'Shop now',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart (${cartItemsList.length})',
                color: color,
                textSize: 22.sp,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethod.warningDialog(
                          title: 'Empty your cart',
                          subTitle: 'are you sure ?',
                          fct: ()async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: Column(
              children: [
                _checkout(context: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext context}) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final orderProvider=Provider.of<OrdersProvider>(context);

    double total=0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
          ? getCurrProduct.salePrice
          : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  User? user = authInstance.currentUser;
                  final productProvider = Provider.of<ProductsProvider>(context,listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      final orderId = const Uuid().v4();

                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                            ? getCurrProduct.salePrice
                            : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      orderProvider.fetchOrders();


                      // TODO fetch the orders here.
                      await Fluttertoast.showToast(
                        msg: "Your order has been placed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                      print(orderId.toString());
                    } catch (error) {
                      GlobalMethod.errorDialog(
                          subTitle: error.toString(), context: context);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                      text: 'Order Now', color: Colors.white, textSize: 20.sp),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
                child: TextWidget(
              text: 'Total :\$${total.toStringAsFixed(2)}',
              color: color,
              textSize: 18.sp,
              isTitle: true,
            ))
          ],
        ),
      ),
    );
  }
}
