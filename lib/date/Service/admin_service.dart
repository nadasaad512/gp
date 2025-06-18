import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/date/modules/notification.dart';
import 'package:gp/date/modules/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Category').get();

      List<CategoryModel> categories = snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<AdminUser?> getUserById(String documentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('admin_users').doc(documentId).get();

      if (doc.exists) {
        return AdminUser.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> addCategoryToUserData(CategoryModel category) async {
    final userId = await getUserId();
    final categoryRef = FirebaseFirestore.instance
        .collection('admin_users')
        .doc(userId)
        .collection('Category');

    // ✅ فحص إذا القسم موجود حسب الاسم
    final existing =
        await categoryRef.where('name', isEqualTo: category.name).get();

    if (existing.docs.isEmpty) {
      // 🟢 القسم غير موجود، نضيفه
      final docRef = await categoryRef.add(category.toMap());
      await docRef.update({'id': docRef.id});
    } else {
      // 🔴 القسم موجود، ما منضيفه
      print('Category "${category.name}" already exists.');
    }
  }

  Future<List<CategoryModel>> userFetchAdminCategories(String id) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_users')
          .doc(id)
          .collection('Category')
          .get();

      List<CategoryModel> categories = snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<CategoryModel>> fetchAdminCategories() async {
    final userId = await getUserId();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .get();

      List<CategoryModel> categories = snapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<void> deleteCategory(BuildContext context, docId) async {
    final userId = await getUserId();

    try {
      await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text("تم حذف القسم بنجاح"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("فشل الحذف: $e");
    }
  }

  Future<void> updateAdminProfile({required AdminUser user}) async {
    final userId = await getUserId();

    try {
      await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .update({
        'name': user.name,
        'phone': user.phone,
        'address': user.address,
        'dec': user.desc,
        'city': user.city,
        'area': user.arae
      });

      print("تم تحديث البيانات بنجاح");
    } catch (e) {
      print("فشل التحديث: $e");
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      String filePath =
          'user_uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> addProducts(
      {required ProductModel product,
      required String catId,
      required File imageFile}) async {
    final userId = await getUserId();
    final userName = await getUserName();

    try {
      String imageUrl = await uploadImageToFirebase(imageFile);

      final productWithImage = ProductModel(
          id: '', // راح يتم تعيينها بعد الإضافة
          name: product.name,
          image: imageUrl,
          dec: product.dec,
          price: product.price,
          focus: product.focus,
          idAdmin: userId.toString(),
          nameAdmin: userName.toString());

      // 3. أضف المنتج إلى Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(catId)
          .collection('products')
          .add(productWithImage.toMap());

      // 4. حدث الـ id داخل المستند
      await docRef.update({'id': docRef.id});

      print('تم إضافة المنتج مع الصورة بنجاح');
    } catch (e) {
      print('خطأ أثناء إضافة المنتج مع الصورة: $e');
    }
  }

  Future<void> updateProduct(
    File? imageFile, {
    required ProductModel updatedProduct,
    required String catId,
  }) async {
    try {
      final userId = await getUserId();
      final userName = await getUserName();

      final productRef = FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(catId)
          .collection('products')
          .doc(updatedProduct.id);

      String? newImageUrl;

      // ✅ إذا تم رفع صورة جديدة، ارفعها واحصل على الرابط
      if (imageFile != null) {
        newImageUrl = await uploadImageToFirebase(imageFile);
      }

      // ✅ تحديث بيانات المنتج
      await productRef.update({
        'id': updatedProduct.id,
        'name': updatedProduct.name,
        'count': updatedProduct.focus,
        'price': updatedProduct.price,
        'dec': updatedProduct.dec,
        'idAdmin': userId.toString(),
        'nameAdmin': userName.toString(),
        'image': newImageUrl ??
            updatedProduct.image, // استخدم الصورة الجديدة أو القديمة
      });
    } catch (e) {
      print("حدث خطأ أثناء تحديث المنتج: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(docId, docIdProduct) async {
    final userId = await getUserId();

    try {
      await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(docId)
          .collection('products')
          .doc(docIdProduct)
          .delete();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: AppColors.primary,
      //     content: Text("تم حذف المنتج بنجاح"),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    } catch (e) {
      print("فشل الحذف: $e");
    }
  }

  Future<List<ProductModel>> getProductsById(String catId) async {
    final userId = await getUserId();
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(catId)
          .collection('products')
          .get();

      List<ProductModel> product = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return product;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchProducts(String catId) async {
    final userId = await getUserId();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_users')
          .doc(userId)
          .collection('categories')
          .doc(catId)
          .collection('products')
          .get();

      List<ProductModel> product = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return product;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> fetchNotification() async {
    try {
      final userId = await getUserId();

      QuerySnapshot snapshot = await _firestore
          .collection('admin_users')
          .doc(userId)
          .collection('Notification')
          .orderBy('createdAt', descending: true)
          .get();

      List<NotificationModel> notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      print("notifff$notifications");

      return notifications;
    } catch (e) {
      print('⚠️ خطأ أثناء جلب الإشعارات: $e');
      return [];
    }
  }
}
