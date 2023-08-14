import 'package:adminpanal/models/products_model.dart';
import 'package:adminpanal/widgets/feed_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/darkThemeProvider.dart';
import '../business_logic/servies/utils.dart';
import '../consts/constt.dart';
import '../providers/products_providers.dart';
import '../providers/products_providers.dart';
import '../providers/products_providers.dart';
import '../widgets/empty_products.dart';
import '../widgets/text_widgets.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController= TextEditingController();
  final FocusNode _searchTextFocusNode =FocusNode();


  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }


  @override
  void initState() {
    final productsProvider= Provider.of<ProductsProvider>(context,listen: false);
   productsProvider.fetchProducts();
    super.initState();
  }
  List<ProductModel> listProductSearch=[];

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;


    final productsProviders =Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts= productsProviders.getProducts;

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'All products',
          color: color,
          textSize: 20.sp,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextFormField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value){
                    setState(() {
                      listProductSearch=productsProviders.searchQuery(value);
                    });
                  },
                  decoration:InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:  BorderSide(color: Colors.greenAccent,width: 1.w)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  BorderSide(color: Colors.greenAccent,width: 1.w)
                    ),
                    hintText: 'what is in your mind',
                    prefixIcon:const Icon(Icons.search),
                    suffix: IconButton(
                        onPressed: (){
                          _searchTextController!.clear();
                          _searchTextFocusNode.unfocus();
                        },
                        icon: Icon(Icons.close,color:_searchTextFocusNode.hasFocus? Colors.red:color,))
                  ) ,
                ),
              ),
            ),


            _searchTextController!.text.isNotEmpty &&
                listProductSearch.isEmpty
                ? const EmptyProWidget(
                text: 'No products found, please try another keyword')
                : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.61),
              children: List.generate(
                  _searchTextController!.text.isNotEmpty
                      ? listProductSearch.length
                      : allProducts.length, (index) {
                return ChangeNotifierProvider.value(
                  value: _searchTextController!.text.isNotEmpty
                      ? listProductSearch[index]
                      : allProducts[index],
                  child: const FeedsWidget(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
