import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gp/features/admain/Main/admainmainscreen.dart';
import 'package:gp/features/splash/widget/choosetypewidget.dart';
import 'package:gp/features/user/main/mainscreen.dart';
import '../Storge/local_storage_service.dart';
import '../modules/admain_user.dart';
import '../modules/client_user.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      String filePath =
          'user_profile/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<String?> adminSignUpWithEmail(
      {required AdminUser user, required File imageFile}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      String imageUrl = await uploadImageToFirebase(imageFile);

      String uid = userCredential.user!.uid;
      print("nada ${uid}");

      await _firestore.collection('admin_users').doc(uid).set({
        'uid': uid,
        'email': user.email,
        'phone': user.phone,
        'city': user.city,
        'arae': user.arae,
        'name': user.name,
        'dec': user.desc,
        'image': imageUrl,
        'address': user.address,
        'type': "admin"
      });

      await LocalStorageService.saveUserData(
        uid: uid,
        name: user.name,
        phone: user.phone,
        city: user.city,
        area: user.arae,
        type: "admin",
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'البريد الإلكتروني مستخدم مسبقًا';
      }
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<String?> clientSignUpWithEmail({required ClientUser user}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('client_users').doc(uid).set({
        'uid': uid,
        'email': user.email,
        'phone': user.phone,
        'city': user.city,
        'age': user.age,
        'area': user.area,
        'gender': user.gender,
        'address': user.address,
        'name1': user.name1,
        'name2': user.name2,
        'type': "client"
      });
      await LocalStorageService.saveUserData(
        uid: uid,
        name: user.name1,
        phone: user.phone,
        city: user.city,
        area: user.area,
        type: "client",
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'البريد الإلكتروني مستخدم مسبقًا';
      }
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }

  logout(BuildContext context) async {
    await LocalStorageService.clearUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChooseTypeWidget()),
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      // جرب أولاً في admin_users
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection("admin_users")
          .doc(uid)
          .get();

      Map<String, dynamic>? userData = userDoc.data();

      // إذا ما لقينا المستخدم هناك، جرب في client_users
      if (userData == null) {
        userDoc = await FirebaseFirestore.instance
            .collection("client_users")
            .doc(uid)
            .get();
        userData = userDoc.data();
      }

      // إذا لقينا البيانات
      if (userData != null) {
        final userType = userData["type"];

        if (userType == "admin") {
          await LocalStorageService.saveUserData(
            uid: uid,
            name: userData["name"],
            phone: userData["phone"],
            city: userData["city"],
            area: userData["arae"], // تأكد من الاسم هنا
            type: "admin",
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdmainMainScreen()),
          );
        } else if (userType == "client") {
          await LocalStorageService.saveUserData(
            uid: uid,
            name: userData["name1"],
            phone: userData["phone"],
            city: userData["city"],
            area: userData["area"],
            type: "client",
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("نوع المستخدم غير معروف")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تعذر العثور على بيانات المستخدم")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateFirebaseError(e.message))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء تسجيل الدخول")),
      );
    }
  }

// دالة لترجمة رسائل Firebase للغة العربية (اختياري)
  String _translateFirebaseError(String? message) {
    if (message == null) return 'حدث خطأ غير متوقع';
    if (message.contains('password is invalid')) return 'كلمة المرور غير صحيحة';
    if (message.contains('no user record')) return 'البريد الإلكتروني غير مسجل';
    if (message.contains('badly formatted'))
      return 'تنسيق البريد الإلكتروني غير صالح';
    return message;
  }

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return 'لم يتم تسجيل الدخول';
      }

      // إعادة التوثيق
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // تحديث كلمة المرور
      await user.updatePassword(newPassword);

      return null; // يعني النجاح
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'كلمة المرور القديمة غير صحيحة';
      }
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<String?> deleteUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return 'لم يتم تسجيل الدخول';
      }

      // جلب بيانات المستخدم المخزنة محليًا لمعرفة نوع المستخدم (admin أو client)
      final userData = await LocalStorageService.getUserData();
      if (userData == null) {
        return 'لم يتم العثور على بيانات المستخدم محلياً';
      }

      final String uid = user.uid;
      final String userType = userData['type'] ?? '';

      // حذف مستند المستخدم من Firestore بناءً على النوع
      if (userType == 'admin') {
        await _firestore.collection('admin_users').doc(uid).delete();
      } else if (userType == 'client') {
        await _firestore.collection('client_users').doc(uid).delete();
      } else {
        return 'نوع المستخدم غير معروف';
      }

      // حذف المستخدم من Firebase Authentication
      await user.delete();

      // حذف البيانات المحلية
      await LocalStorageService.clearUserData();

      return null; // النجاح
    } on FirebaseAuthException catch (e) {
      // إذا احتاج المستخدم إعادة تسجيل الدخول (مثلاً بسبب صلاحية توثيق منتهية)
      if (e.code == 'requires-recent-login') {
        return 'يرجى إعادة تسجيل الدخول لإكمال عملية الحذف';
      }
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع أثناء الحذف';
    }
  }
}
