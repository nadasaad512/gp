import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gp/date/Service/user_service.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/date/modules/client_user.dart';
import 'package:gp/date/modules/products.dart';

class UserProvider with ChangeNotifier {
  final UserService _userervice = UserService();

  List<CategoryModel> category = [];
  List<AdminUser> nearbyPharmac = [];
  List<ProductModel> products = [];
  List<CartModel> cart = [];
  List<CartModel> request = [];
  List<ProductModel> recommended = [];
  ClientUser? user;
  CartModel? oneProduct;

  Future<List<CategoryModel>> fetchCategories() async {
    category = await _userervice.fetchCategories();
    notifyListeners();
    return category;
  }

  Future<ClientUser?> fetchProfile() async {
    user = await _userervice.fetchProfile();
    notifyListeners();
    return user;
  }

  Future<List<AdminUser>> fetchNearbyPharmac({required String area}) async {
    print("area${area}");
    nearbyPharmac = await _userervice.fetchNearbyPharmac(area);
    notifyListeners();
    return nearbyPharmac;
  }

  Future<List<ProductModel>> fetchProducts({required String name}) async {
    products = await _userervice.fetchProducts(name);
    notifyListeners();
    return products;
  }

  Future<List<ProductModel>> userFetchProducts(
      {required String userId, required String name}) async {
    products = await _userervice.userFetchProducts(userId, name);
    notifyListeners();
    return products;
  }

  Future<void> filterfetchProducts({
    required String name,
    required String selectedProvince,
    required String selectedArea,
  }) async {
    products = await _userervice.filterfetchProducts(
      name: name,
      selectedProvince: selectedProvince,
      selectedArea: selectedArea,
    );
    products;
    print("tessssss${products}");
    notifyListeners();
  }

  Future addProductToCart(BuildContext context,
      {required CartModel cartData}) async {
    await _userervice.addProductToCart(context, cartData: cartData);
    await fetchCart();

    notifyListeners();
    return products;
  }

  Future editProductToCart(
    BuildContext context, {
    required String docId,
    required int newQuantity,
  }) async {
    await _userervice.updateProductQuantityByDocId(
        context: context, docId: docId, newQuantity: newQuantity);
    await fetchCart();
    notifyListeners();
    return products;
  }

  Future<List<CartModel>> fetchCart() async {
    cart = await _userervice.getCart();
    notifyListeners();
    return cart;
  }

  Future confirmCart(
    BuildContext context, {
    required List<CartModel> cartList,
  }) async {
    await _userervice.confirmCart(context, cartList: cartList);
    await fetchCart();
    notifyListeners();
    return products;
  }

  Future<void> deletProductToCart(
    BuildContext context, {
    required String idProduct,
  }) async {
    await _userervice.deletProductToCart(context, idProduct: idProduct);
    await fetchCart();
    notifyListeners();
  }

  Future<List<CartModel>> getRequest() async {
    request = await _userervice.getRequest();
    notifyListeners();
    return cart;
  }

  Future getRecommended() async {
    recommended = await _userervice.getRecommended();

    notifyListeners();
  }

  getOneProduct(CartModel cart) async {
    oneProduct = await _userervice.getOneProduct(cart);
    notifyListeners();
  }
}
