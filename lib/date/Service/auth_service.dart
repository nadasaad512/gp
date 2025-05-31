import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        'name1': user.name1,
        'name2': user.name2,
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

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Check admin
      DocumentSnapshot adminDoc =
          await _firestore.collection('admin_users').doc(uid).get();
      if (adminDoc.exists) {
        final data = adminDoc.data() as Map<String, dynamic>;
        AdminUser admin = AdminUser.fromMap(data);

        await LocalStorageService.saveUserData(
          uid: admin.uid,
          name: admin.name,
          phone: admin.phone,
          city: admin.city,
          area: admin.arae,
          type: "admin",
        );

        return "admin";
      }

      // Check client
      DocumentSnapshot clientDoc =
          await _firestore.collection('client_users').doc(uid).get();
      if (clientDoc.exists) {
        final data = clientDoc.data() as Map<String, dynamic>;
        ClientUser client = ClientUser.fromMap(data);

        await LocalStorageService.saveUserData(
          uid: client.uid,
          name: client.name1,
          phone: client.phone,
          city: client.city,
          area: client.area,
          type: "client",
        );

        return "client";
      }

      return 'لم يتم العثور على بيانات المستخدم';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    }
  }
}
