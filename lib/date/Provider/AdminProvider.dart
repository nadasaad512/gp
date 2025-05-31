import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp/date/Service/admin_service.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/date/modules/notification.dart';
import 'package:gp/date/modules/products.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<CategoryModel> category = [];
  List<ProductModel> products = [];
  List<CategoryModel> adminCategory = [];
  List<NotificationModel> notification = [];
  AdminUser? adminUser;

  Future<List<CategoryModel>> fetchCategories() async {
    category = await _adminService.fetchCategories();
    notifyListeners();
    return category;
  }

  Future<AdminUser?> getUserById(String documentId) async {
    adminUser = await _adminService.getUserById(documentId);
    notifyListeners();
    return adminUser;
  }

  Future<void> addCategoryToUserData(CategoryModel category) async {
    await _adminService.addCategoryToUserData(category);
    await fetchAdminCategories();
    notifyListeners();
  }

  Future<List<CategoryModel>> fetchAdminCategories() async {
    adminCategory = await _adminService.fetchAdminCategories();
    notifyListeners();
    return adminCategory;
  }

  Future<void> updateAdminProfile(AdminUser user) async {
    await _adminService.updateAdminProfile(user: user);
  }

  Future<void> addProducts(
      ProductModel product, String catId, File imageFile) async {
    await _adminService.addProducts(
        product: product, catId: catId, imageFile: imageFile);
    await getProductsById(catId);
    notifyListeners();
  }

  Future<void> editProducts(
    File? imageFile, {
    required ProductModel updatedProduct,
    required String catId,
  }) async {
    await _adminService.updateProduct(imageFile,
        updatedProduct: updatedProduct, catId: catId);
    await getProductsById(catId);
    notifyListeners();
  }

  Future<List<ProductModel>> getProductsById(String catId) async {
    products = [];
    products = await _adminService.getProductsById(catId);
    notifyListeners();
    return products;
  }

  Future<List<ProductModel>> fetchProducts(String catId) async {
    return await _adminService.fetchProducts(catId);
  }

  Future<List<NotificationModel>> fetchNotification() async {
    notification = await _adminService.fetchNotification();
    notifyListeners();
    return notification;
  }
}
