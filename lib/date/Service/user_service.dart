import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp/core/app_colors.dart';
import 'package:gp/date/modules/admain_user.dart';
import 'package:gp/date/modules/cart.dart';
import 'package:gp/date/modules/category.dart';
import 'package:gp/date/modules/client_user.dart';
import 'package:gp/date/modules/notification.dart';
import 'package:gp/date/modules/orders.dart';
import 'package:gp/date/modules/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<ClientUser?> fetchProfile() async {
    final userId = await getUserId();
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('client_users').doc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return ClientUser.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<ClientUser?> getUserData() async {
    try {
      final userId = await getUserId();

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('client_users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return ClientUser.fromMap(data);
      } else {
        print('المستخدم غير موجود');
        return null;
      }
    } catch (e) {
      print('خطأ أثناء جلب بيانات المستخدم: $e');
      return null;
    }
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

  Future<List<AdminUser>> fetchNearbyPharmac(String area) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('admin_users')
          .where('arae', isEqualTo: area)
          .get();

      List<AdminUser> admins = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AdminUser.fromMap(data);
      }).toList();

      return admins;
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> filterfetchProducts({
    required String name,
    required String selectedProvince,
    required String selectedArea,
  }) async {
    List<ProductModel> allProducts = [];

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('admin_users').get();

    // دالة صغيرة لتنظيف النصوص (تحويل لحروف صغيرة وإزالة فراغات زائدة)
    String normalizeText(String input) => input.trim().toLowerCase();

    for (final userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final userData = userDoc.data();
      final adminProvince = (userData['city'] ?? '').toString();
      final adminArea = (userData['arae'] ?? '').toString();

      print(
          "🔍 Checking admin: uid=$userId, province=$adminProvince, area=$adminArea");

      final matchProvince =
          normalizeText(adminProvince) == normalizeText(selectedProvince);
      final matchArea = normalizeText(adminArea) == normalizeText(selectedArea);

      if (matchProvince && matchArea) {
        print("✅ MATCHED ADMIN: $userId");

        // جلب الفئة (category) بالاسم المطلوب فقط
        final categoriesSnapshot = await FirebaseFirestore.instance
            .collection('admin_users')
            .doc(userId)
            .collection('Category')
            .where('name', isEqualTo: name)
            .get();

        for (final categoryDoc in categoriesSnapshot.docs) {
          final categoryId = categoryDoc.id;

          final productsSnapshot = await FirebaseFirestore.instance
              .collection('admin_users')
              .doc(userId)
              .collection('Category')
              .doc(categoryId)
              .collection('products')
              .get();

          for (final productDoc in productsSnapshot.docs) {
            final productData = productDoc.data();

            // أنشئ موديل المنتج من الداتا
            final product = ProductModel.fromMap(productData);

            allProducts.add(product);
            print("🟢 Added product from $userId");
          }
        }
      } else {
        print("❌ Skipped admin: $userId");
      }
    }

    print("📦 عدد المنتجات بعد الفلترة: ${allProducts.length}");

    return allProducts;
  }

  Future<List<ProductModel>> userFetchProducts(
      String userId, String name) async {
    List<ProductModel> allProducts = [];

    // جلب الفئات التي لها نفس الاسم داخل المستخدم المحدد
    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('admin_users')
        .doc(userId)
        .collection('Category')
        .where('name', isEqualTo: name)
        .get();

    for (final categoryDoc in categoriesSnapshot.docs) {
      final categoryId = categoryDoc.id;

      final productsSnapshot = await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .doc(categoryId)
          .collection('products')
          .get();

      for (final productDoc in productsSnapshot.docs) {
        final productData = productDoc.data();
        final product = ProductModel.fromMap(productData);
        allProducts.add(product);
        print(allProducts.length);
      }
    }

    return allProducts;
  }

  Future<List<ProductModel>> fetchProducts(String name) async {
    List<ProductModel> allProducts = [];

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('admin_users').get();

    for (final userDoc in usersSnapshot.docs) {
      final userId = userDoc.id;
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userId)
          .collection('Category')
          .where('name', isEqualTo: name)
          .get();

      for (final categoryDoc in categoriesSnapshot.docs) {
        final categoryId = categoryDoc.id;

        final productsSnapshot = await FirebaseFirestore.instance
            .collection('admin_users')
            .doc(userId)
            .collection('Category')
            .doc(categoryId)
            .collection('products')
            .get();

        for (final productDoc in productsSnapshot.docs) {
          final productData = productDoc.data();
          final product = ProductModel.fromMap(productData);
          allProducts.add(product);
          print(allProducts.length);
        }
      }
    }

    return allProducts;
  }

  Future<void> addProductToCart(
    BuildContext context, {
    required CartModel cartData,
  }) async {
    final userId = await getUserId();
    final cartRef = FirebaseFirestore.instance
        .collection('client_users')
        .doc(userId)
        .collection('cart');

    try {
      // تحقق مما إذا كان المنتج موجودًا بالفعل في السلة
      final existingProductQuery = await cartRef
          .where('id', isEqualTo: cartData.product.id)
          .limit(1)
          .get();

      if (existingProductQuery.docs.isNotEmpty) {
        // المنتج موجود مسبقًا → تحديث الكمية
        final existingDoc = existingProductQuery.docs.first;
        final currentQuantity = existingDoc['quantity'] ?? 1;
        await existingDoc.reference.update({
          'quantity': currentQuantity + 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text('تم تحديث كمية المنتج في السلة.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // المنتج غير موجود → إضافة جديدة مع حفظ docId في idCat
        final newDoc = cartRef.doc(); // توليد docId
        cartData.idcart = newDoc.id; // حفظه في cartData
        await newDoc.set(cartData.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text('تمت إضافة المنتج بنجاح إلى السلة.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('حدث خطأ أثناء إضافة المنتج: $e');
    }
  }

  Future<void> updateProductQuantityByDocId({
    required BuildContext context,
    required String docId, // معرف وثيقة المنتج في السلة
    required int newQuantity,
  }) async {
    final userId = await getUserId();
    final docRef = FirebaseFirestore.instance
        .collection('client_users')
        .doc(userId)
        .collection('cart')
        .doc(docId);

    try {
      await docRef.update({
        'quantity': newQuantity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('تم تعديل كمية المنتج بنجاح.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('حدث خطأ أثناء تعديل كمية المنتج: $e');
    }
  }

  Future<List<CartModel>> getCart() async {
    final userId = await getUserId();

    try {
      final snapshot = await _firestore
          .collection('client_users')
          .doc(userId)
          .collection('cart')
          .get();

      List<CartModel> cartItems = snapshot.docs.map((doc) {
        return CartModel.fromMap(doc.data());
      }).toList();

      return cartItems;
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  Future<void> confirmCart(
    BuildContext context, {
    required List<CartModel> cartList,
  }) async {
    final userId = await getUserId();
    ClientUser? user = await getUserData();

    try {
      // 1. إرسال الطلبات وحذفها من السلة
      for (CartModel cartData in cartList) {
        await FirebaseFirestore.instance
            .collection('client_users')
            .doc(userId)
            .collection('Request')
            .add(cartData.toMap());

        await getRecommendedProductsFromCategory(cartData.namecart);

        if (cartData.product.id != null) {
          await FirebaseFirestore.instance
              .collection('client_users')
              .doc(userId)
              .collection('cart')
              .doc(cartData.idcart)
              .delete();
        }
      }

      // 2. تجميع المنتجات حسب الصيدلية
      Map<String, List<ProductItemModel>> groupedProducts = {};
      for (var cartData in cartList) {
        final idAdmin = cartData.product.idAdmin;
        groupedProducts.putIfAbsent(idAdmin, () => []);
        groupedProducts[idAdmin]!.add(
          ProductItemModel(
            nameProduct: cartData.product.name,
            countProduct: cartData.quantity.toString(),
            price: cartData.product.price,
          ),
        );
      }

      // 3. تجهيز قائمة الإشعارات بدون createdAt
      List<NotificationModel> notifications = [];
      groupedProducts.forEach((idAdmin, products) {
        notifications.add(
          NotificationModel(
            id: "",
            nameUser: "${user!.name1} ${user.name2}",
            addressUser: user.address,
            phoneUser: user.phone,
            idAdmin: idAdmin,
            products: products,
            createdAt: null, // نتركها null لأنها فقط للقراءة
            isSeen: false,
          ),
        );
      });

      // 4. إرسال الإشعارات
      await sendNotification(notifications);

      // 5. إشعار النجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('تم ارسال طلبك بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('حدث خطأ أثناء تأكيد السلة: $e');
    }
  }

  Future<List<NotificationModel>> sendNotification(
      List<NotificationModel> orders) async {
    final Map<String, List<NotificationModel>> grouped = {};

    for (var order in orders) {
      grouped.putIfAbsent(order.idAdmin, () => []);
      grouped[order.idAdmin]!.add(order);
    }

    List<NotificationModel> addedNotifications = [];

    for (var entry in grouped.entries) {
      final idAdmin = entry.key;
      final orderList = entry.value;

      final products = orderList.expand((order) => order.products).toList();

      final notificationData = {
        'nameUser': orderList.first.nameUser,
        'addressUser': orderList.first.addressUser,
        'phoneUser': orderList.first.phoneUser,
        'idAdmin': idAdmin,
        'products': products.map((e) => e.toMap()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'isSeen': false,
      };

      // 🟢 نضيف الإشعار ونأخذ الـ id
      final docRef = await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(idAdmin)
          .collection('Notification')
          .add(notificationData);

// ✳️ أضف الـ id داخل المستند
      await docRef.update({'id': docRef.id});

      // 🟢 نضيف نسخة من NotificationModel مع id
      addedNotifications.add(
        NotificationModel(
          id: docRef.id, // ← أضف الـ id هنا
          nameUser: orderList.first.nameUser,
          addressUser: orderList.first.addressUser,
          phoneUser: orderList.first.phoneUser,
          idAdmin: idAdmin,
          products: products,
          createdAt: null, // فقط للقراءة لاحقًا
          isSeen: false,
        ),
      );
    }

    return addedNotifications;
  }

  Future<void> deletProductToCart(
    BuildContext context, {
    required String idProduct,
  }) async {
    final userId = await getUserId();
    print("id ${idProduct}");

    try {
      await FirebaseFirestore.instance
          .collection('client_users')
          .doc(userId)
          .collection('cart')
          .doc(idProduct)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('تم حذف المنتج بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {}
  }

  Future<List<CartModel>> getRequest() async {
    final userId = await getUserId();

    try {
      final snapshot = await _firestore
          .collection('client_users')
          .doc(userId)
          .collection('Request')
          .get();

      List<CartModel> cartItems = snapshot.docs.map((doc) {
        return CartModel.fromMap(doc.data());
      }).toList();

      return cartItems;
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  Future<List<ProductModel>> getRecommendedProductsFromCategory(
      String categoryName) async {
    List<ProductModel> recommendedProducts = [];
    final userId = await getUserId();

    // Get all admin users
    QuerySnapshot usersSnapshot =
        await _firestore.collection('admin_users').get();

    for (var userDoc in usersSnapshot.docs) {
      try {
        // نجيب الأقسام ونفلتر حسب اسم القسم (name)
        QuerySnapshot categoriesSnapshot = await _firestore
            .collection('admin_users')
            .doc(userDoc.id)
            .collection('Category')
            .where('name', isEqualTo: categoryName)
            .limit(1)
            .get();

        if (categoriesSnapshot.docs.isEmpty) {
          continue;
        }

        // جلب أول قسم مطابق
        var categoryDoc = categoriesSnapshot.docs.first;
        var categoryId = categoryDoc.id;

        // الآن نجيب المنتجات من هذا القسم
        CollectionReference productsRef = _firestore
            .collection('admin_users')
            .doc(userDoc.id)
            .collection('Category')
            .doc(categoryId)
            .collection('products');

        QuerySnapshot productsSnapshot = await productsRef.limit(1).get();

        if (productsSnapshot.docs.isNotEmpty) {
          var productData =
              productsSnapshot.docs.first.data() as Map<String, dynamic>;

          ProductModel product = ProductModel.fromMap(productData);

          recommendedProducts.add(product);

          // خزّن المنتج في كولكشن recommended
          await _firestore
              .collection('client_users')
              .doc(userId)
              .collection('recommended')
              .add(productData);
        }
      } catch (e) {
        // في حال حدوث خطأ أو القسم مش موجود
        continue;
      }
    }

    return recommendedProducts;
  }

  Future<List<ProductModel>> getRecommended() async {
    final userId = await getUserId();

    try {
      final snapshot = await _firestore
          .collection('client_users')
          .doc(userId)
          .collection('recommended')
          .get();

      List<ProductModel> productItems = snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList();

      return productItems;
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  Future<CartModel?> getOneProduct(CartModel cart) async {
    try {
      // أولًا: نبحث عن التصنيف بناءً على الاسم
      final categorySnapshot = await _firestore
          .collection('admin_users')
          .doc(cart.product.idAdmin)
          .collection('Category')
          .where('name', isEqualTo: cart.namecart)
          .get();

      if (categorySnapshot.docs.isEmpty) {
        print('التصنيف غير موجود');
        return null;
      }

      // نحصل على ID التصنيف الصحيح
      final categoryDocId = categorySnapshot.docs.first.id;

      // ثم ندخل إلى مجموعة المنتجات داخل هذا التصنيف
      final productSnapshot = await _firestore
          .collection('admin_users')
          .doc(cart.product.idAdmin)
          .collection('Category')
          .doc(categoryDocId)
          .collection('products')
          .doc(cart.product.id)
          .get();

      if (productSnapshot.exists) {
        return CartModel.fromMap(productSnapshot.data()!);
      } else {
        print('المنتج غير موجود داخل هذا التصنيف');
        return null;
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب المنتج: $e');
      return null;
    }
  }
}
