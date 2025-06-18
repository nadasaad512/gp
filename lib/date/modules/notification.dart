import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp/date/modules/orders.dart';

class NotificationModel {
  final String nameUser;
  final String id;
  final String addressUser;
  final String phoneUser;
  final String idAdmin;
  final List<ProductItemModel> products;
  final DateTime? createdAt; // هذا لقراءة التاريخ فقط
  final bool isSeen;

  NotificationModel({
    required this.id,
    required this.nameUser,
    required this.addressUser,
    required this.phoneUser,
    required this.idAdmin,
    required this.products,
    required this.createdAt,
    required this.isSeen,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      nameUser: map['nameUser'] ?? '',
      id: map['id'] ?? '',
      addressUser: map['addressUser'] ?? '',
      phoneUser: map['phoneUser'] ?? '',
      idAdmin: map['idAdmin'] ?? '',
      products: (map['products'] as List<dynamic>?)
              ?.map((item) => ProductItemModel.fromMap(item))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      isSeen: map['isSeen'] ?? false,
    );
  }
}
