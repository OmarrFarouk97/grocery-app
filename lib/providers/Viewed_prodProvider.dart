import 'package:adminpanal/models/viewed_model.dart';
import 'package:adminpanal/models/wishlist_model.dart';
import 'package:flutter/cupertino.dart';

class ViewedProdProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _viewedProdListItems = {};

  Map<String, ViewedProdModel> get getViewedProdListItems {
    return _viewedProdListItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdListItems.putIfAbsent(
        productId,
            () => ViewedProdModel(
            id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _viewedProdListItems.clear();
    notifyListeners();
  }
}
